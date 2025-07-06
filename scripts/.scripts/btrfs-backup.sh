#!/bin/sh


backup_dir="/backup/snapshots"
subvolumes=("/" "/home" "/data")
max_snapshots=30
min_snapshots=7
log_file="/var/log/btrfs/backup.log"
log_dir="/var/log/btrfs"

mkdir -p $log_dir

log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$log_file"
}

log "备份开始"

datestamp=$(date '+%Y%m%d')
snapshot_name="snapshot_$datestamp"

mkdir -p "$backup_dir/$snapshot_name"

for subvol in "${subvolumes[@]}"; do
	if [ "$subvol" = "/" ]; then
		subvol_name="root"
	else
		subvol_name=$(basename "$subvol" | tr -d '/') 
	fi
	snapshot_path="$backup_dir/$snapshot_name/$subvol_name"

	log "为 $subvol 创建快照到 $snapshot_path"
	sudo btrfs subvolume snapshot -r "$subvol" "$snapshot_path"

	if [ $? -eq 0 ]; then
		log "快照创建成功：$snapshot_path"
	else
		log "快照创建失败：$snapshot_path"
	fi
done

log "开始清理过期快照..."
all_snapshots=$(fd -t d -d 1 "snapshot_.*" "$backup_dir" | sort)
snapshot_cnt=$(echo $all_snapshots | wc -l)

to_remove_cnt=$((snapshot_cnt - max_snapshots))

if [ $to_remove_cnt -gt 0 ]; then
	log "删除 $to_remove_cnt 个快照（当前快照 $snapshot_cnt 个，最大保留 $max_snapshots 个"

	old_snapshots=$(echo "$all_snapshots" | head -n $to_remove_cnt)

	for old_snap in $old_snapshots; do
		sudo btrfs subvolume delete "$old_snap*"
		if [ $? -eq 0]; then
			log "快照删除成功：$old_snap"
		else
			log "快照删除失败：$old_snap"
		fi
	done
else
	log "当前快照数量($snapshot_cnt)未超过最大限制($max_snapshots)无需清理"
fi

log "备份完成"
