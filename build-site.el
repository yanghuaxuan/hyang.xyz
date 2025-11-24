(require 'ox-publish)
(require 'package)

(package-initialize)

(require 'htmlize)

(setq org-html-head-include-default-style nil
      org-html-head (concat
		     "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"
		     "<link rel=\"stylesheet\" href=\"./custom.css\">"))

(setq org-html-preamble
      (concat "<header style=\"padding-top: 5px\">"
	          "<a href=\"./index.html\"><b>/home/hyang</b></a>"
                  "<nav style=\"display: flex\">"
		      "<a href=\"./blog.html\">blogpostings</a>"
		      "<a href=\"./blog.html\">projects</a>"
		      "<a href=\"./resume.pdf\">resume.pdf</a>"
		      "<a href=\"./sitemap.html\" style=\"margin-left: auto\">...</a>"
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
       (list "static"
	     :base-directory "./static"
	     :recursive t
	     :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|svg"
	     :publishing-directory "./public"
	     :publishing-function 'org-publish-attachment
	     )))

(org-publish-all)

(message "Build complete")
