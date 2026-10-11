fn main() {
    let arg = std::env::args().nth(1);
    match arg.as_deref() {
        Some("--version") | Some("-V") => println!("hello-sandbox {}", env!("CARGO_PKG_VERSION")),
        _ => println!("hello from the attest sandbox"),
    }
}
