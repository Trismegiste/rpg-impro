<vertex-form>
    <form class="pure-form" onsubmit="return false" onchange="{
                onChange
            }">
        <textarea placeholder="Hashtag" id="hashtag" name="hashtag" class="pure-input-1" rows="1">{ model.hashtag }</textarea>
        <textarea name="sentence" id="sentence" class="pure-input-1" rows="3">{ model.sentence }</textarea>
        <div class="pure-g">
            <div class="pure-u-1-2">
                <button class="pure-button" onclick="{
                            onCancel
                        }">Annuler</button>
            </div>
            <div class="pure-u-1-2">
                <button class="pure-button" onclick="{
                            onCreate
                        }">Ajouter</button>
            </div>
        </div>
    </form>
    <script>
        var self = this
        this.model = {
            hashtag: '',
            sentence: ''
        }

        this.onCreate = function () {
            RpgImpro.document.addUniqueVertex(self.model)
            RpgImpro.repository.addUniqueVertex(self.model)
        }

        this.onChange = function () {
            self.model.hashtag = self.hashtag.value.trim()
            self.model.sentence = self.sentence.value.trim()
        }

        this.on('mount', function () {
            var Textarea = Textcomplete.editors.Textarea
            var autocompleted = ["hashtag", 'sentence']
            var editor = [], tc = []

            for (var k in autocompleted) {
                var key = autocompleted[k]
                var textAreaElem = document.getElementById(key)
                editor[k] = new Textarea(textAreaElem)
                tc[k] = new Textcomplete(editor[k], {
                    dropdown: Infinity
                })
            }

            tc[0].register([
                {
                    match: /(^)([^\s]+)$/,
                    search: function (term, callback) {
                        var repo = RpgImpro.repository.vertex
                        var found = []
                        for (var k in repo) {
                            var v = repo[k]
                            if ((v.hashtag.search(term) !== -1) && (found.indexOf(v.hashtag) === -1)) {
                                found.push(v.hashtag)
                            }
                        }

                        callback(found)
                    },
                    replace: function (value) {
                        return value + ' '
                    }
                }
            ])

            tc[1].register([
                {
                    match: /(^|\s)#([^\s]+)$/,
                    search: function (term, callback) {
                        var repo = RpgImpro.repository.vertex
                        var found = []
                        for (var k in repo) {
                            var v = repo[k]
                            if ((v.hashtag.search(term) !== -1) && (found.indexOf(v.hashtag) === -1)) {
                                found.push(v.hashtag)
                            }
                        }

                        callback(found)
                    },
                    replace: function (value) {
                        return '$1#' + value + ' '
                    }
                },
                {
                    match: /(^)([^\s]+)$/,
                    search: function (term, callback) {
                        var repo = RpgImpro.repository.vertex
                        var filter = self.model.hashtag

                        var found = []
                        for (var k in repo) {
                            var v = repo[k]
                            if (filter.length && (v.hashtag !== filter)) {
                                continue
                            }
                            if ((v.sentence.search(term) !== -1) && (found.indexOf(v.sentence) === -1)) {
                                found.push(v)
                            }
                        }

                        callback(found)
                    },
                    template: function (obj) {
                        return obj.sentence
                    },
                    replace: function (obj) {
                        self.model.hashtag = obj.hashtag
                        self.update()
                        return obj.sentence + ' '
                    }
                }
            ])

        })

    </script>
</vertex-form>