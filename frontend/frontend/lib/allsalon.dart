import 'package:flutter/material.dart';

class AllItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Items'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          _buildItem(
            'Дюц спорт заал',
            'БЗД, Монел Аргал ойл колонкийн хойно зам дагуу замынхаа зүүн талд',
            '50,000₮',
            '09:00-23:59',
            'assets/images/zaal1.jpg',
          ),
          _buildItem(
            'M23 спорт заал',
            'ЧД, Зурагт Буурал ээж автобусны буудлын Миний супермаркетын хойд талд',
            '70,000₮',
            '08:00-23:59',
            'assets/images/zaal2.jpg',
          ),
          _buildItem(
            'Улаанбаатар Эрдэм Их Сургууль',
            'ЧД, Тэнгис кино театрын зүүн хойд талд',
            '70,000₮',
            '10:00-23:59',
            'assets/images/zaal3.jpg',
          ),
          _buildItem(
            'Монос Трейд спорт заал',
            'БГД, ТЭЦ 4-ийн зүүн урд талд',
            '80,000₮',
            '10:00-21:59',
            'assets/images/zaal4.jpg',
          ),
          _buildItem(
            'SS спорт центр',
            'ЧД, Баянбүрд тойргийн баруун хойд талд',
            '60,000₮',
            '08:00-21:59',
            'assets/images/zaal5.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String location, String price, String time, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: Colors.black.withOpacity(0.6),
                  child: Text(
                    time,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange, size: 16),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  price,
                  style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
