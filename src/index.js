const nlp = require('nlp_compromise'),
      r = require('ramda');

const app = Elm.Main.fullscreen();

const log = r.tap(x => {console.log(x);});

const match = r.curry(
    (spec, [cmd, val]) => spec[
        r.find(
            r.equals(cmd),
            r.keys(spec)
        )
    ](val)
);

app.ports.nlpCmd.subscribe(
    r.pipe(
        log,
        match({
            Past: val => nlp.sentence(val).to_past().text()
        }),
        app.ports.nlpResp.send
    )
);
