@override
Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(

onPressed: () async {
    if (_formKey.currentState!.validate()) {
        // Kirim ke Django dan tunggu respons
        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
        final response = await request.postJson(
            "http://localhost:8000/create-flutter/",
            jsonEncode(<String, String>{
                'product_name': _product_name,
                'price': _price.toString(),
                'rating': _rating,
                'reviews': _reviews,
            // TODO: Sesuaikan field data sesuai dengan aplikasimu
            }),
        );
        if (context.mounted) {
            if (response['status'] == 'success') {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                content: Text("Produk baru berhasil disimpan!"),
                ));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                );
            } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    content:
                        Text("Terdapat kesalahan, silakan coba lagi."),
                ));
            }
        }
    }
},