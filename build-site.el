(require 'ox-publish)
(require 'package)

(package-initialize)

(require 'htmlize)

(setq org-html-head-include-default-style nil
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

(setq org-html-preamble
      (concat "<header>"
                  "<nav style=\"display: flex\">"
		  "<a href=\"./index.html\">index</a>"
		  "<a href=\"./blog.html\">blogpostings</a>"
		  "<a href=\"./resume.pdf\">resume.pdf</a>"
		  "<a href=\"./sitemap.html\" style=\"margin-left: auto\">...</a>"
		  "</nav>"
	      "</header>"))


(setq org-publish-project-alist
      (list
       (list "hyang.xyz"
	     :recursive nil
	     :base-directory "./content"
	     :publishing-directory "./public"
	     :publishing-function 'org-html-publish-to-html
	     :auto-sitemap t
	     ;; :html-preamble t
	     :with-author nil
	     :time-stamp-file nil
	     :html-validation-link nil
	     :section-numbers nil)))

(org-publish-all)

(message "Build complete")
