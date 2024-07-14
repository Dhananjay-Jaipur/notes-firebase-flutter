import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // object of firestore::
  final Firestore objFirestore = Firestore();

  // text controller - to get text from the text field
  // final - used to create objects of immutable nature
  final TextEditingController textController = TextEditingController();

  void addButton({String? dId}){

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: TextField(
              controller: textController,
              // add a button in textfield
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: (){
                      // add in database
                      objFirestore.addNote(textController.text);

                      // close dilogbox
                      Navigator.pop(context);

                      // clear text controler
                      textController.clear();
                    },
                  icon: const Icon(Icons.save),
                ),
              ),
            ),
          ),
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("............."),),
      ),

      floatingActionButton: FloatingActionButton(onPressed: addButton, backgroundColor: Colors.grey ,child: const Icon(Icons.add_outlined, color: Colors.black87, size: 30,),),

      // Stream - streams, we can send one data event at a time while other parts of your app listen for those events. Streams can send errors in addition with data & we can also stop that stream
      // use to download
      body: StreamBuilder<QuerySnapshot>(

        // use to get data
        stream: objFirestore.getNote(),

        // UI::
        builder: (context, snapshot){

          List notesList = snapshot.data!.docs;

          return ListView.builder(

              itemCount: notesList.length,

              itemBuilder: (context, index)
              {

                DocumentSnapshot document = notesList[index];
                String docId = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: ListTile(
                        title: Text(noteText),
                        // add a button alonside
                        trailing: IconButton(
                            onPressed: () => objFirestore.update(docId, textController.text),
                            icon: Icon(Icons.edit)
                        ),

                      ),
                    ),
                );

              },
          );
        },
      ),


    );
  }
}
