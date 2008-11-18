structure OCaml : COMPILER = struct
  val languageName = "ocaml"
  val ext = "ml"
  val base = OS.Path.base
  fun mkExe infile = base infile
  fun mkCmd infile = concat ["ocamlc -o ", base infile, " ", infile]
  fun detritus infile = map (fn s => concat [base infile, ".", s]) ["cmi", "cmo"]
end
