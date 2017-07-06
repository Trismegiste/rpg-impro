<google-drive-doc-save>
    <form class="pure-form form-label-aligned" onsubmit="{
                onBackup
            }">
        <h2>Document</h2>
        <div class="pure-g">
            <div class="pure-u-1-4"><label>Nom</label></div>
            <div class="pure-u-3-4"><input class="pure-input-1" type="text"
                                           name="filename" value="{backupName}"
                                           placeholder="A filename to backup to"
                                           required="true"/>
            </div>
            <div class="pure-u-1-4"><label>Folder</label></div>
            <div class="pure-u-3-4"><input class="pure-input-1" type="text"
                                           name="folder" required="true" readonly="true"
                                           value="{driveFolder.name}"
                                           placeholder="Click to pick a folder"
                                           onclick="{
                                                       onFolderPicking
                                                   }"/>
            </div>
            <div class="pure-u-1-4"></div>
            <div class="pure-u-3-4">
                <button class="pure-button button-error" if="{driveFolder.id}">
                    Backup to Google Drive
                </button>
            </div>
        </div>
    </form>

    <script>
        var self = this
        this.driveFolder = {}
        this.backupName = 'Sans-Titre'
        this.message = ''
        this.mixin('toasty')

        this.onFolderPicking = function () {
            cloudClient.pickOneFolder()
                    .then(function (choice) {
                        self.driveFolder = choice
                        self.update()
                    })
        }

        // upload to google
        this.onBackup = function () {
            var temp = RpgImpro.document

            cloudClient.saveFile(self.filename.value, 'application/json', JSON.stringify(temp), self.driveFolder.id)
                    .then(function (rsp) {
                        self.notice(temp.vertex.length + ' vertices saved', 'success')
                    })
        }
    </script>
</google-drive-doc-save>