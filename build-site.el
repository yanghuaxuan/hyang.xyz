(require 'ox-publish)
(require 'package)

(package-initialize)

(require 'htmlize)

(setq org-html-head-include-default-style nil
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

(setq org-publish-project-alist
      (list
       (list "hyang.xyz"
	     :recursive nil
	     :base-directory "./content"
	     :publishing-directory "./public"
	     :publishing-function 'org-html-publish-to-html
	     :auto-sitemap t
	     :with-author nil
	     :time-stamp-file nil
	     :html-validation-link nil
	     :section-numbers nil)))

(org-publish-all)

(message "Build complete")
