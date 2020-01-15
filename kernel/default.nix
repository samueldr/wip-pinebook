{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.4.0-rc6";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStrings (intersperse "." (take 3 (splitString "." "${version}.0"))) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchFromGitHub {
    owner = "anarsoul";
    repo = "linux-2.6";
    # sunxi64-5.2
    rev = "2f54e4ab245801c718d91464f1b2e29c4ca20d10";
    sha256 = "1d6xkr9vz333yxwnjfdijv57nbjq5rqbikjiqjfzqjpjz7yghlq9";
  };
} // (args.argsOverride or {}))
