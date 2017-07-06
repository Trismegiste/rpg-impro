<google-drive-doc-load>
    <form class="pure-form form-label-aligned" onsubmit="{
                onImport
            }">
        <h2>Document</h2>
        <div class="pure-g">
            <div class="pure-u-1-4"><label>Backup file</label></div>
            <div class="pure-u-3-4"><input class="pure-input-1" type="text"
                                           name="filename" required="true" readonly="true"
                                           value="{backup.name}"
                                           placeholder="Click to pick a file"
                                           onclick="{
                                                       onFilePicking
                                                   }"/>
            </div>
            <div class="pure-u-1-4"></div>
            <div class="pure-u-3-4">
                <button class="pure-button button-primary" if="{backup.id}">
                    Import from Google Drive
                </button>
            </div>
        </div>
    </form>

    <script>
        var self = this
        this.backup = {}
        this.mixin('toasty')

        this.onFilePicking = function () {
            cloudClient.pickOneFile('application/json')
                    .then(function (choice) {
                        self.backup = choice
                        self.update()
                    })
        }

        // download from google
        this.onImport = function () {
            gapi.client.drive.files.get({
                fileId: self.backup.id,
                alt: 'media'
            }).then(function (rsp) {
                var graph = rsp.result
                RpgImpro.document.vertex = graph.vertex
                RpgImpro.document.edge = graph.edge
                self.notice(graph.vertex.length + ' vertices imported', 'success')
            })

        }

    </script>
</google-drive-doc-load>