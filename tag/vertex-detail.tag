<vertex-detail id="selected">
    <article>
        <div class="pure-g">
            <div class="pure-u-11-12">
                <mark class="hashtag">{vertex.hashtag}</mark>
            </div>
            <div class="pure-u-1-12">
                <a href="#">E</a>
            </div>
            <div class="pure-u-11-12">
                <hashtag-decorator str="{vertex.sentence}" inner="{ vertex.pk }"></hashtag-decorator>
            </div>
            <div class="pure-u-1-12">
                <a href="#">E</a>
            </div>
            <div class="pure-u-11-12">
                <ul class="edges edges-outer">
                    <li each="{ RpgImpro.document.getVertexBySource(vertex.pk) }">
                        <a href="#show/{pk}" class="hashtag">{ hashtag }</a>
                    </li>
                </ul>
            </div>
            <div class="pure-u-1-12">
                <a onclick="{
                            onAddOuter
                        }">+</a>
            </div>
            <div class="pure-u-1" if="{ viewOuter }">
                <textarea name="outer" rows="1" class="pure-input-1"></textarea>
            </div>
            <div class="pure-u-11-12">
                <ul class="edges edges-inner">
                    <li each="{ RpgImpro.document.getVertexByTarget(vertex.pk) }">
                        <a href="#show/{pk}" class="hashtag">{ hashtag }</a>
                    </li>
                </ul>
            </div>
            <div class="pure-u-1-12">
                <a href="#">+</a>
            </div>
            <div class="pure-u-1">
            </div>
        </div>
    </article>
    <script>
        var self = this
        this.viewOuter = false
        this.onAddOuter = function () {
            self.viewOuter = true
            self.initTA(self.outer)
        }

        this.initTA = function (textAreaElem) {
            var Textarea = Textcomplete.editors.Textarea
            var editor = [], tc = null

            editor = new Textarea(textAreaElem)
            tc = new Textcomplete(editor, {
                dropdown: Infinity
            })

            tc.register([
                {
                    match: /(^)([^\s]+)$/,
                    search: function (term, callback) {
                        var repo = RpgImpro.document.getVertex()
                        var found = []
                        for (var k in repo) {
                            var v = repo[k]
                            if (v.sentence.search(term) !== -1) {
                                found.push(v)
                            }
                        }

                        callback(found)
                    },
                    template: function (obj) {
                        return '#' + obj.hashtag + ' ' + obj.sentence
                    },
                    replace: function (value) {
                        return value.pk
                    }
                }
            ])

            tc.on('selected', function () {
                var pk = self.outer.value
                self.outer.value = ''
                self.viewOuter = false
                RpgImpro.document.addEdge(self.vertex.pk, pk)
                self.update()
            })

        }

    </script>
</vertex-detail>