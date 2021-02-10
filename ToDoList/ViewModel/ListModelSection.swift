import Foundation

enum Sections: Hashable, CaseIterable {
  case Monday, Tuesday, Wednesday, Thursday, Friday
}

struct ListModelSection:Hashable{
    let sectionName:String
    var items:[ListModel]
}


