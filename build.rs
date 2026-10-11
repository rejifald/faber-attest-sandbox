// Stamps the commit the stand-in was built from, as `+g<7 hex>`: GITHUB_SHA in
// CI, `git rev-parse HEAD` locally.
fn main() {
    println!("cargo:rerun-if-env-changed=GITHUB_SHA");
    let sha = std::env::var("GITHUB_SHA")
        .ok()
        .filter(|s| !s.is_empty())
        .or_else(|| {
            std::process::Command::new("git")
                .args(["rev-parse", "HEAD"])
                .output()
                .ok()
                .filter(|o| o.status.success())
                .map(|o| String::from_utf8_lossy(&o.stdout).trim().to_string())
        })
        .unwrap_or_else(|| "0000000".to_string())
        .to_ascii_lowercase();
    println!("cargo:rustc-env=STANDIN_SHA={}", &sha[..7]);
}
