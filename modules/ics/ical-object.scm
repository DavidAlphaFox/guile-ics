;; Copyright (C) 2016, 2017 Artyom V. Poptsov <poptsov.artyom@gmail.com>
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
  #:use-module (oop goops)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)            ; find
  #:use-module (ics ical-property)
  #:use-module (ics ical-content)
  #:export (<ical-object>
            ical-object->ics
            ical-object-name
            ical-object-properties
            ical-object-property-ref
            ical-object-components))


;;;

(define-class <ical-object> (<ical-content>)
  ;; list
  (properties #:accessor ical-object-properties
              #:init-value '()
              #:init-keyword #:properties)
  ;; list
  (components #:accessor ical-object-components
              #:init-value '()
              #:init-keyword #:components))


;;; Custom printers

(define-method (display (ical-object <ical-object>) (port <port>))
  (format port "#<ical-object ~a ~a>"  (ical-object-name ical-object)
          (number->string (object-address ical-object) 16)))

(define-method (write (ical-object <ical-object>) (port <port>))
  (format port "#<ical-object ~a ~a>"  (ical-object-name ical-object)
          (number->string (object-address ical-object) 16)))


;;;

(define ical-object-name ical-content-name)


;;;

(define-method (ical-object-property-ref (ical-object <ical-object>)
                                         (name <string>))
  "Get an iCalendar property by a NAME, return the property object or
#f if no property found."
  (find (lambda (property) (equal? (ical-property-name property) name))
        (ical-object-properties ical-object)))


(define-method (ical-object->ics (obj <ical-object>)
                                 (port <port>))
  (define (escape-chars text)
    (regexp-substitute/global #f "[\n]"
                              (regexp-substitute/global #f "([\\;,])"
                                                        text
                                                        'pre "\\" 0 'post)
                              'pre "\\n" 'post))

  (define (scm->ical-value value)
    (if (list? value)
        (string-join (map escape-chars value) ",")
        (escape-chars value)))

  (define (print-properties props)
    (for-each (lambda (e)
                (format port "~a" (ical-property-name e))
                (for-each (lambda (property)
                            (format port ";~a=~a"
                                    (car property)
                                    (cdr property)))
                          (ical-property-parameters e))
                (let ((value (ical-property-value e)))
                  (if (list? value)
                      (ical-format port ":~a"
                                   (string-join (map scm->ical-value
                                                     value)
                                                ","))
                      (ical-format port ":~a" (scm->ical-value value)))))

              props))
  (define (print-components components)
    (for-each (lambda (object)
                (let ((cname (ical-object-name object)))
                  (ical-format port "BEGIN:~a" cname)
                  (print-properties (ical-object-properties object))
                  (print-components (ical-object-components object))
                  (ical-format port "END:~a" cname)))
              components))
  (define (print-vcalendar)
    (ical-write-line "BEGIN:VCALENDAR" port)
    (print-properties (ical-object-properties obj))
    (print-components (ical-object-components obj))
    (ical-write-line "END:VCALENDAR" port))

  (print-vcalendar))

;;; ical-object.scm ends here.
