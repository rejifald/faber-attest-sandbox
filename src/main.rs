//! Release-flow stand-in. Prints `faber <version>+g<sha>` for `--version`,
//! accepts `check-config` with any arguments, and refuses everything else: it
//! never runs a daemon, so a host that installs it learns only that the
//! release flow delivered it.

const VERSION: &str = concat!(env!("CARGO_PKG_VERSION"), "+g", env!("STANDIN_SHA"));

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    match args.first().map(String::as_str) {
        Some("--version") | Some("-V") => println!("faber {VERSION}"),
        Some("check-config") => {
            println!("stand-in {VERSION}: check-config accepted (nothing is parsed)")
        }
        Some("provenance-policy") => {
            println!("policy: stand-in");
            println!("note: a release-flow test fixture; it verifies nothing");
        }
        _ => {
            eprintln!("stand-in {VERSION}: a release-flow test fixture; it does not run anything");
            std::process::exit(2);
        }
    }
}
