import SwiftUI

struct LearnView: View {
    private let vm = LearnViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Group {
                Button("Set Data") {
                    vm.setDataWithAnId()
                }
                
                Button("Data Types") {
                    vm.saveDifferentDataTypes()
                }
                
                Button("Custom Object") {
                    vm.saveCustomObject()
                }
                
                Button("Nested Field") {
                    vm.updateNestedField()
                }
                
                Button("Update Array") {
                    vm.updateArray()
                }
                
                Button("Update Number") {
                    vm.updateNumber()
                }
            }
            
            Group {
                Button("Delete") {
                    vm.delete()
                }
                
                Button("Transaction") {
                    vm.transaction()
                }
                
                Button("Batch") {
                    vm.batch()
                }
                
                Button("Add Listener to NY") {
                    vm.addListenerToNY()
                }
                
                Button("Change NY") {
                    vm.changeNY()
                }
                
                
                Button("Add Listener to CA") {
                    vm.addListenerToCA()
                }
                
                Button("Cities in CA") {
                    vm.addCitiesInCA()
                }
            }
            
            Group {
                Button("Sub Collection") {
                    vm.subcollection()
                }
                
                Button("Order and Limit") {
                    vm.orderAndLimit()
                }
            }
            
            Spacer()
        }
        .padding(.top, 30)
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
