;;; setup-docker.el ---                            -*- lexical-binding: t; -*-

;; Copyright (C) 2014-2020  Abelardo Jara-Berrocal

;; Author: Abelardo Jara-Berrocal <abelardojarab@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

;; dockerfile-mode is pretty self explanatory
(use-package dockerfile-mode
  :mode "\\Dockerfile\\'")

;; Allows TRAMP connections into running containers
(use-package docker-tramp
  :after tramp
  :defer 5)

;; Docker allows for interaction with the Docker distribution
(use-package docker
  :defer t
  :diminish t
  :commands (docker-containers
             docker-volumes
             docker-networks
             docker-build
             docker-build-buffer
             hydra-docker/body)
  :init (progn
          (use-package docker-image
            :commands docker-images)
          (use-package docker-container
            :commands docker-containers)
          (use-package docker-volume
            :commands docker-volumes)
          (use-package docker-network
            :commands docker-containers)
          (use-package docker-machine
            :commands docker-machines)
          (use-package docker-compose
            :commands docker-compose))
  :bind ("C-c d" . docker-containers)
  :hydra (hydra-docker (:columns 5 :color blue)
                       "Docker"
                       ("c" docker-containers "Containers")
                       ("v" docker-volumes "Volumes")
                       ("i" docker-images "Images")
                       ("n" docker-networks "Networks")
                       ("b" dockerfile-build-buffer "Build Buffer")
                       ("q" nil "Quit")))

;; Docker compose files
(use-package docker-compose-mode
  :defer t
  :mode ("docker-compose.*\.yml\\'" . docker-compose-mode))

(provide 'setup-docker)
;;; setup-org-docker.el ends here
