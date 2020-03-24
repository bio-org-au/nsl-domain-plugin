/*
    Copyright 2015 Australian National Botanic Gardens

    This file is part of NSL-domain-plugin.

    Licensed under the Apache License, Version 2.0 (the "License"); you may not
    use this file except in compliance with the License. You may obtain a copy
    of the License at http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/
includeTargets << grailsScript("_GrailsInit")
includeTargets << new File("${grailsSettings.projectPluginsDir}/hibernate4-4.3.5.5/scripts/SchemaExport.groovy")

target(main: "Generate the NSL ddl sql from the current schema including views") {
    //schema-export --datasource=nsl
    argsMap.datasource = 'nsl'
    schemaExport()
    File ddl = new File("${grailsSettings.projectTargetDir}/ddl.sql")
    String text = ddl.text
                     .replaceAll(/alter table/, 'alter table if exists')
                     .replaceAll(/drop table/, 'drop table if exists')
                     .replaceAll(/boolean not null/, 'boolean default false not null')
                     .replaceAll(/create sequence nsl_global_seq;/, '')
                     .replaceAll(/drop sequence nsl_global_seq;/, 'drop sequence nsl_global_seq;\n    create sequence nsl_global_seq minvalue 1000 maxvalue 10000000;')
                     .replaceAll(/create sequence hibernate_sequence;/, '')
                     .replaceAll(/drop sequence hibernate_sequence;/, 'drop sequence hibernate_sequence;\n    create sequence hibernate_sequence;')

    File dataDir = new File("${grailsSettings.baseDir}/web-app/sql")
    File viewsDir = new File(dataDir, 'views')
    File nslDdl = new File(dataDir, "nsl-ddl.sql")
    nslDdl.write(text)
    viewsDir.listFiles().sort().each { File view ->
        println "Adding ${view.absolutePath}"
        nslDdl.append("\n-- ${view.name}\n")
        nslDdl.append(view.text)
    }

}

setDefaultTarget(main)
