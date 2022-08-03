import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';

import './screens/product_detail_screen.dart';
// import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            // This empty parenthsis and list is need to initialize variable
            create: (ctx) => Products("", "", []),
            update: (ctx, auth, previousProducts) => Products(
                auth.token ?? '',
                auth.userId ?? '',
                previousProducts == null ? [] : previousProducts.items))

        // ChangeNotifierProxyProvider<Auth, Products>(
        //   builder: (ctx, auth, previousProducts) => Products(auth.token, previousProducts.items),
        // ),
        ,
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders("", "", []),
          update: (ctx, auth, previousOrders) => Orders(
              auth.token ?? '',
              auth.userId ?? '',
              previousOrders == null ? [] : previousOrders.orders),
        )
        // ChangeNotifierProvider.value(value: Orders())
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (
                    ctx,
                    authResultSnapshot,
                  ) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            // '/prouduct-detail': (ctx) => ProductDetailScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("MyShop"),
//       ),
//       body: const Center(
//         child: Text('Let\'s build a shop!'),
//       ),
//     );
//   }
// }
