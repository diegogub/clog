;;; This is a template to help jump start a CLOG-GUI App

(defpackage #:clog-user
  (:use #:cl #:clog #:clog-gui)
  (:export start-app))

(in-package :clog-user)

(defun on-file-new (obj)
  (let* ((app (connection-data-item obj "builder-app-data"))
	 (win (create-gui-window obj :title "New Window")))
    (declare (ignore app win))))

(defun on-help-about (obj)
  (let* ((about (create-gui-window obj
				   :title   "About"
				   :content "<div class='w3-black'>
                                         <center><img src='/img/clogwicon.png'></center>
	                                 <center>CLOG</center>
	                                 <center>The Common Lisp Omnificent GUI</center></div>
			                 <div><p><center>A New App</center>
                                         <center>(c) 2021 - David Botton</center></p></div>"
				   :hidden  t
				   :width   200
				   :height  200)))
    (window-center about)
    (setf (visiblep about) t)
    (set-on-window-can-size about (lambda (obj)
				    (declare (ignore obj))()))))

(defclass app-data ()
  ((data
    :accessor data)))

(defun on-new-window (body)
  (let ((app (make-instance 'app-data)))
    (setf (connection-data-item body "app-data") app)
    (setf (title (html-document body)) "New App")
    (clog-gui-initialize body)
    (add-class body "w3-teal")  
    (let* ((menu-bar    (create-gui-menu-bar body))
	   (icon-item   (create-gui-menu-icon menu-bar :on-click #'on-help-about))
	   (file-item   (create-gui-menu-drop-down menu-bar :content "File"))
	   (file-new    (create-gui-menu-item file-item :content "New Window" :on-click #'on-file-new))
	   (help-item   (create-gui-menu-drop-down menu-bar :content "Help"))
	   (help-about  (create-gui-menu-item help-item :content "About" :on-click #'on-help-about))
	   (full-screen (create-gui-menu-full-screen menu-bar)))
      (declare (ignore icon-item file-new help-about full-screen))
      (run body))))

(defun start-app ()
  (initialize #'on-new-window)
  ;; Setup asdf for project and can use
  ;;	      :static-root (merge-pathnames "./static-files/"
  ;;			     (asdf:system-source-directory :proj-name)))
  (open-browser))
