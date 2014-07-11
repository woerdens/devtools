#!/bin/bash
#// File: jirabackup.sh
#//
#// Author(s): Maaz Ghani
#
#// Open Source eCommerce for the discriminating retailer.
#//
#// Built on Go, by gophers.
#//
#// To contribute or use Ottemo, please visit:
#//  github.com/ottemo/
#//
#// License and Copyright
#//  Copyright (c) 2014 Ottemo
#//
#//  Permission is hereby granted, free of charge, to any person obtaining a copy
#//  of this software and associated documentation files (the "Software"), to deal
#//  in the Software without restriction, including without limitation the rights
#//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#//  copies of the Software, and to permit persons to whom the Software is
#//  furnished to do so, subject to the following conditions:
#//
#//  The above copyright notice and this permission notice shall be included in all
#//  copies or substantial portions of the Software.
#//
#//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#//  SOFTWARE.

CONFIG_FILE='/opt/atlassian/jira/conf/jirabackup.conf'
TIMESTAMP=$(date +'%Y-%m-%d-%H-%M')

if [ -e ${CONFIG_FILE} ]; then
  source ${CONFIG_FILE}
else
  echo "Error: ${CONFIG_FILE} not found"
  exit 1
fi

ATTACHMENT_BACKUP="${BACKUP_DIR}/jira-attachments-${TIMESTAMP}.tar"
SQLDUMP="${BACKUP_DIR}/jira-database-dump-${TIMESTAMP}.sql"

function setup()
{
  if [ ! -d "${BACKUP_DIR}" ]; then
    echo "Creating ${BACKUP_DIR}"
    mkdir -p "${BACKUP_DIR}"
  fi
}

function backup_attachments()
{
  echo "Backing up JIRA Attachments"
  /bin/tar -cpf ${ATTACHMENT_BACKUP} ${ATTACHMENT_PATH}
  echo "Created ${ATTACHMENT_BACKUP}"
}

function mysqldump()
{
  echo "Dumping MySQL JIRA Database"
  /usr/bin/mysqldump -u "${DB_USER}" -p"${DB_PASS}" --all-databases > "${SQLDUMP}"
  echo "Created {$SQLDUMP}"
}

function main()
{
  echo "Backing up JIRA"
  setup
  backup_attachments
  mysqldump
}

main
