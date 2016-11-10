import Guaka
import ENV

let p = Command(name: "print",  
                shortUsage: "print can be used to print stuff", 
                longUsage: "print is just the commands you need, it print everything to the console") 
{ flags, args in
  print(flags["prefix"]!.value!)
  print(args.joined())
  print(flags["postfix"]!.value!)
  
  if let additional = Env.get("ADDITIONAL") {
    print(additional)
  }
}

p.add(flag: Flag(longName: "prefix", value: "", shortName: "p", description: "prints a prefix"))
p.add(flag: Flag(longName: "postfix", value: "", description: "prints a postfix"))

p.execute()
