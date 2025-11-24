(require 'ox-publish)
(require 'package)

(package-initialize)

(require 'htmlize)

(setq org-html-head-include-default-style nil
      org-html-head (concat
		     "<link rel=\"icon\" href=\"/static/favicon.ico\">"
		     "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"
		     "<link rel=\"stylesheet\" href=\"/static/custom.css\">"))

(setq org-html-preamble
      (concat "<header style=\"padding-top: 2em\">"
	          "<a href=\"/index.html\"><b>/home/hyang</b></a>"
                  "<nav style=\"display: flex\">"
		      "<a href=\"/blog.html\">blogpostings</a>"
		      "<a href=\"/projects.html\">projects</a>"
		      "<a href=\"/static/resume.pdf\">resume.pdf</a>"
		      "<a href=\"/sitemap.html\" style=\"margin-left: auto\">...</a>"
		      "</nav>"
	      "</header>"))


(setq org-publish-project-alist
      (list
       (list "hyang.xyz"
	     :base-directory "./content"
	     :recursive nil
	     :publishing-directory "./public"
	     :publishing-function 'org-html-publish-to-html
	     :auto-sitemap t
	     ;; :html-preamble t
	     :with-author nil
	     :time-stamp-file nil
	     :html-validation-link nil
	     :section-numbers nil)
       (list "hall of shame"
	     :base-directory "./content/hall_of_shame"
	     :recursive nil
	     :publishing-directory "./public/hall_of_shame"
	     :publishing-function 'org-html-publish-to-html
	     :auto-sitemap nil
	     ;; :html-preamble t
	     :with-author nil
	     :time-stamp-file nil
	     :html-validation-link nil
	     :section-numbers nil)
       (list "blogpostings"
	     :base-directory "./content/blogpostings"
	     :recursive nil
	     :publishing-directory "./public/blogpostings"
	     :publishing-function 'org-html-publish-to-html
	     :auto-sitemap nil
	     ;; :html-preamble t
	     :with-author nil
	     :time-stamp-file nil
	     :html-validation-link nil
	     :section-numbers nil)
       (list "static"
	     :base-directory "./static"
	     :recursive t
	     :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|svg\\|ico"
	     :publishing-directory "./public/static"
	     :publishing-function 'org-publish-attachment
	     )))

(org-publish-all)

(message "Build complete")
