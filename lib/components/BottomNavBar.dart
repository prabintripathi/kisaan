import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static int _selectedIndex = 0;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/bazaar');
        break;
      case 1:
        Navigator.of(context).pushNamed('/myproducts');
        break;
      case 2:
        Navigator.of(context).pushNamed('/me');
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.white,
      backgroundColor: Colors.redAccent,
      items: [
        BottomNavigationBarItem(
            //this will take to the person's things of needs in agriculture anything one wants to buy such as seeds or fertilizers.
            label: 'बजार',
            icon: Icon(Icons.local_grocery_store)),
        BottomNavigationBarItem(
            //this will take to the products listed on the marketplace, can edit if needs and see the real time status of orders gone or still pending
            label: 'मेरो उत्पादन',
            icon: Icon(
              Icons.agriculture,
            )),
        BottomNavigationBarItem(
            //this will take to person's account page. later on whole transactions, ratings and all.
            label: 'म',
            icon: Icon(Icons.person))
      ],
    ));
  }
}
