;; Copyright (C) 2016 Artyom V. Poptsov <poptsov.artyom@gmail.com>
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

(define-module (ics ical-object)
  #:export (ical-object-icalprops
            ical-object-component
            ->ical-object))

(define (->ical-object icalprops component)
  (list (cons 'ICALPROPS (list icalprops))
        (cons 'COMPONENT (list component))))


(define (ical-object-icalprops ical-object)
  (cadr (assoc 'ICALPROPS ical-object)))

(define (ical-object-component ical-object)
  (cadr (assoc 'COMPONENT ical-object)))

;;; ical-object.scm ends here.