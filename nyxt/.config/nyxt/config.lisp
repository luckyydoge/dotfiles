(define-configuration buffer
  ((default-modes
    (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))

(define-configuration nyxt/mode/proxy:proxy-mode
  ((nyxt/mode/proxy:proxy
     (make-instance 'proxy
		    :url (quri:uri "socks5://localhost:10800")
		    :proxied-downloads-p t))))

(define-configuration web-buffer
  ((default-modes (append '(proxy-mode) %slot-default%))))

(define-configuration prompt-buffer
  ((default-modes 
     (append '(nyxt/mode/vi:vi-insert-mode) %slot-default%))))

