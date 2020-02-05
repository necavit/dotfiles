#!/usr/bin/env python
# PYTHON_ARGCOMPLETE_OK

# The comment before activates argument completion, in global completion mode (i.e.
#   you don't need to register this script for completion, if the mode is activated)
#   Please see https://pypi.python.org/pypi/argcomplete/1.0.0 for more information

import argparse
import argcomplete
import os
import json
import sys
import subprocess

def loadTemplates():
  filePath = os.path.join(os.path.expanduser('~'),'.gitconfig_templates')
  with open(filePath, 'rb') as templatesFile:
    return json.load(templatesFile)

def listTemplates():
  templates = loadTemplates()
  for template in templates:
    print(template['template_name'] + ':')
    print('  user.name:  ' + template['user_name'])
    print('  user.email: ' + template['user_email'] + '\n')
  sys.exit()

def configure(name, email):
  userNameCmd  = u'git config user.name "%s"' % name
  userEmailCmd = u'git config user.email "%s"' % email
  print(userNameCmd)
  subprocess.call(userNameCmd, shell=True)
  print(userEmailCmd)
  subprocess.call(userEmailCmd, shell=True)
  sys.exit()

def configWithCustom():
  print('Configuring repository with custom values.')
  name =  raw_input('  user.name: ').decode(sys.stdin.encoding)
  email = raw_input('  user.email: ').decode(sys.stdin.encoding)
  configure(name, email)

def configWithTemplate(templateName):
  if templateName == None:
    print('ERROR! You need to provide a template name!')
    sys.exit()
  else:
    print('Using template: ' + templateName)
    template = [x for x in loadTemplates() if x['template_name'] == templateName][0]
    configure(template['user_name'],
              template['user_email'])

def gitconfig(args):
  if args.list:
    listTemplates()
  elif args.custom:
    configWithCustom()
  else:
    configWithTemplate(args.template)

def getTemplateNames():
  templates = loadTemplates()
  names = []
  for t in templates:
    names.append(t['template_name'])
  return names

if __name__ == '__main__':
  templateNames = getTemplateNames()

  # top level argument parser
  parser = argparse.ArgumentParser(
                      description='Applies a Git configuration to the current repository, using predefined configuration templates, stored in ~/.gitconfig_templates')
  parser.add_argument('-l', '--list',
                      help='lists the available configuration templates', action='store_true')
  parser.add_argument('-c', '--custom',
                      help='configure the repository with custom variables', action='store_true')
  parser.add_argument('template', metavar='TEMPLATE',
                      choices=templateNames, nargs='?')
  excludedAutocompletions = ['-l','--list','-c','--custom','-h','--help']
  argcomplete.autocomplete(parser, exclude=excludedAutocompletions)
  args = parser.parse_args()

  # main procedure
  gitconfig(args)
