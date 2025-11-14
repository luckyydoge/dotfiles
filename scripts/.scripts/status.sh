# #!/bin/bash
#
# # --- 获取信息 ---
# # 1. 时间
# CURRENT_TIME=$(date "+%H:%M:%S")
#
# # 2. 电池电量 (假设电池名为 BAT0)
# BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
# if [ -z "$BATTERY_CAPACITY" ]; then
#     BATTERY_STATUS="N/A"
# else
#     BATTERY_STATUS="${BATTERY_CAPACITY}%"
# fi
#
# # 3. 内存使用 (使用 free 和 awk 提取已用内存，-h 表示人类可读格式)
# MEM_USED=$(free -h | awk '/Mem:/ {print $3}')
#
# # --- 格式化消息 ---
# MESSAGE_TITLE="系统状态更新"
#
# # 使用换行符 \n 格式化通知内容
# MESSAGE_BODY="⌚ 时间: ${CURRENT_TIME}\n🔋 电量: ${BATTERY_STATUS}\n🧠 内存占用: ${MEM_USED}"
#
# # --- 发送通知给 mako ---
# # -u low: 设置优先级为低
# # -t 3000: 设置通知显示 3000 毫秒 (3 秒) 后自动消失
# notify-send -u low -t 5000 "$MESSAGE_TITLE" "$MESSAGE_BODY"
#!/bin/bash

# ===============================================
# 函数：获取内存使用百分比
# ===============================================
get_memory_usage() {
    # 使用 free 命令获取内存信息 (KiB)
    MEM_TOTAL=$(free | awk '/Mem:/ {print $2}')
    MEM_USED=$(free | awk '/Mem:/ {print $3}')
    MEM_TOTAL_H=$(free -h | awk '/Mem:/ {print $2}')
    MEM_USED_H=$(free -h | awk '/Mem:/ {print $3}')
    
    # 避免除以零错误
    if [ "$MEM_TOTAL" -eq 0 ]; then
        echo "0"
        return
    fi
    
    # 计算百分比: (已用 / 总量) * 100
    PERCENT=$(( 100 * MEM_USED / MEM_TOTAL ))
    echo "$PERCENT% $MEM_USED_H/$MEM_TOTAL_H"
}

# ===============================================
# 函数：获取电池电量
# ===============================================
get_battery_status() {
    # 尝试查找第一个 BAT 设备
    BATTERY_PATH=$(find /sys/class/power_supply/ -maxdepth 1 -type l -name "BAT*" -o -name "LCBT" -print -quit 2>/dev/null)
    if [ -z "$BATTERY_PATH" ]; then
        echo "N/A"
        return
    fi
    # 获取容量
    CAPACITY_FILE="$BATTERY_PATH/capacity"
    STATUS_FILE="$BATTERY_PATH/status"

 if [ -f "$CAPACITY_FILE" ]; then
        CAPACITY=$(cat "$CAPACITY_FILE")
        
        # 1. 获取充电状态
        STATUS=""
        if [ -f "$STATUS_FILE" ]; then
            STATUS=$(cat "$STATUS_FILE")
        fi

        # 2. 根据电量和状态选择图标
        ICON=""
        
        # 正在充电的图标
        if [ "$STATUS" = "Charging" ]; then
            # 充电图标（可以根据电量细分，这里简化为通用充电图标）
            if [ "$CAPACITY" -eq 100 ]; then
                ICON="󰂅" # Full
            elif [ "$CAPACITY" -ge 90 ]; then
                ICON="󰂋" # 90-99
            elif [ "$CAPACITY" -ge 80 ]; then
                ICON="󰂊" # 80-89
            elif [ "$CAPACITY" -ge 70 ]; then
                ICON="󰢞" # 70-79
            elif [ "$CAPACITY" -ge 60 ]; then
                ICON="󰂉" # 60-69
            elif [ "$CAPACITY" -ge 50 ]; then
                ICON="󰢝" # 50-59
            elif [ "$CAPACITY" -ge 40 ]; then
                ICON="󰂈" # 40-49
            elif [ "$CAPACITY" -ge 30 ]; then
                ICON="󰂇" # 30-39
            elif [ "$CAPACITY" -ge 20 ]; then
                ICON="󰂆" # 20-29
            elif [ "$CAPACITY" -ge 10 ]; then
                ICON="󰢜" # 10-19
            else
                ICON="󰢟" # 0-9 (临界低电量)
            fi
        # 未充电的图标
        else
            if [ "$CAPACITY" -eq 100 ]; then
                ICON="󰁹" # Full
            elif [ "$CAPACITY" -ge 90 ]; then
                ICON="󰂂" # 90-99
            elif [ "$CAPACITY" -ge 80 ]; then
                ICON="󰂁" # 80-89
            elif [ "$CAPACITY" -ge 70 ]; then
                ICON="󰂀" # 70-79
            elif [ "$CAPACITY" -ge 60 ]; then
                ICON="󰁿" # 60-69
            elif [ "$CAPACITY" -ge 50 ]; then
                ICON="󰁾" # 50-59
            elif [ "$CAPACITY" -ge 40 ]; then
                ICON="󰁽" # 40-49
            elif [ "$CAPACITY" -ge 30 ]; then
                ICON="󰁼" # 30-39
            elif [ "$CAPACITY" -ge 20 ]; then
                ICON="󰁻" # 20-29
            elif [ "$CAPACITY" -ge 10 ]; then
                ICON="󰁺" # 10-19
            else
                ICON="󰂃" # 0-9 (临界低电量)
            fi
        fi
        
        # 3. 组合最终输出
        BODY="${ICON} ${CAPACITY}%"
        echo "$BODY"   
 fi

}

get_volume_status() {
    RESULT=""
    STATUS=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$STATUS" = "no" ]; then
        VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/Volume:/ {print $5}' | sed 's/[%|,]//g')
        if [ "$VOLUME" -ge 60 ]; then
            RESULT=" "
        elif [ "$VOLUME" -ge 30 ]; then
            RESULT=" "
        else 
            RESULT=" "
        fi
        RESULT+="${VOLUME}"
    else 
        RESULT=" "
    fi
    echo "$RESULT"
}

get_network_status() {
    RESULT=""
    STATUS=$(nmcli -t -f DEVICE,CONNECTION,TYPE dev status | rg wlan0 | awk -F ':' '{print $2}')
    if [ -z "$STATUS" ]; then
        RESULT="󱚵 "
    else
        RESULT="󰖩 $STATUS"
    fi
    echo "$RESULT"
}

# ===============================================
# 主程序
# ===============================================

# 1. 获取动态信息
CURRENT_TIME=$(date "+%a %d %H:%M:%S")
BATTERY_STATUS=$(get_battery_status)
MEM_PERCENT=$(get_memory_usage)
VOLUME_STATUS=$(get_volume_status)
NETWORK_STATUS=$(get_network_status)

# 2. 格式化通知内容 (使用 \n 换行)
MESSAGE_TITLE="系统状态更新"

MESSAGE_BODY="󰃰 ${CURRENT_TIME}\n"
MESSAGE_BODY+="${BATTERY_STATUS}\n"
MESSAGE_BODY+=" ${MEM_PERCENT}\n"
MESSAGE_BODY+="${VOLUME_STATUS}\n"
MESSAGE_BODY+="${NETWORK_STATUS}\n"

# 3. 发送通知给 mako
# -u low: 设置优先级为低
# -t 3000: 设置通知显示 3000 毫秒 (3 秒)
notify-send -u critical -t 5000 "" "$MESSAGE_BODY"
