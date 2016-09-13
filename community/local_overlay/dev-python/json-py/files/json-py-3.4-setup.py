#!/usr/bin/env python

from distutils.core import setup

setup(name="json-py",
      version="3.4",
      description="JSON (JavaScript Object Notation) is a lightweight data-interchange format",
      classifiers=["Development Status :: 4 - Beta",
                   "Intended Audience :: Developers",
		   "License :: OSI Approved :: GNU Library or Lesser General Public License (LGPL)", 
                   "Programming Language :: Python",
                   "Topic :: Software Development :: Libraries :: Python Modules",
                   ],
      author="Patrick D. Logan",
      author_email="patrickdlogan@users.sourceforge.net",
			url="http://json.org",
      license="LGPL",
      py_modules=["json", "minjson","jsontest"],
      )

# Send announce to:
#   python-announce@python.org
#   python-list@python.org
