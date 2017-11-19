;;; ics.scm -- Type tests for ICS parser.

;; Copyright (C) 2017 Artyom V. Poptsov <poptsov.artyom@gmail.com>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; The program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with the program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:


;;; Code:

(use-modules (srfi srfi-64)
             (oop goops)
             (ice-9 rdelim)
             (ics)
             (ics common)
             (ics parser)
             (ics type object)
             (ics type property))

(test-begin "types")


;;;

(test-assert "type: binary: make"
  (let ((p (make <ics-property:binary>
             #:name "ATTACH"
             #:format-type "image/vnd.microsoft.icon"
             #:encoding    'BASE64
             #:value       "AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAgIAAAICAgADAwMAA////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMwAAAAAAABNEMQAAAAAAAkQgAAAAAAJEREQgAAACECQ0QgEgAAQxQzM0E0AABERCRCREQAADRDJEJEQwAAAhA0QwEQAAAAAEREAAAAAAAAREQAAAAAAAAkQgAAAAAAAAMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")))
    p))

(test-assert "type: boolean: make"
  (let ((p (make <ics-property:boolean>
             #:name  "NON-SMOKING"
             #:value #t)))
    p))

(test-assert "type: cal-address: make"
  (let ((p (make <ics-property:cal-address>
             #:name       "ORGANIZER"
             #:value      "mailto:jsmith@example.com"
             #:parameters '((CN . "John Smith")))))
    p))

(test-assert "type: date: make"
  (let ((p (make <ics-property:date>
             #:name "RDATE"
             #:value (strptime "%Y%m%d" "19970714"))))
    p))


;;;

(test-end "types")

(exit (= (test-runner-fail-count (test-runner-current)) 0))

;;; types.scm ends here.