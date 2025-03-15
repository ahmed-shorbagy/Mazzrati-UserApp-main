import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/screens/auction_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/banners_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/footer_banner_slider_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/single_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/featured_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/flash_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/featured_deal_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/active_auction_list__widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/announcement_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/find_what_you_need_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/featured_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/search_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/widgets/square_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/home_category_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/products_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/recommended_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/screens/search_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/all_shop_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/top_seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static Future<void> loadData(bool reload) async {
    await Provider.of<FlashDealController>(Get.context!, listen: false)
        .getFlashDealList(reload, false);
    await Provider.of<ShopController>(Get.context!, listen: false)
        .getTopSellerList(reload, 1, type: "top");
    Provider.of<BannerController>(Get.context!, listen: false)
        .getBannerList(reload);
    Provider.of<CategoryController>(Get.context!, listen: false)
        .getCategoryList(reload);
    Provider.of<AddressController>(Get.context!, listen: false)
        .getAddressList();
    await Provider.of<CartController>(Get.context!, listen: false)
        .getCartData(Get.context!);

    await Provider.of<ProductController>(Get.context!, listen: false)
        .getHomeCategoryProductList(reload);
    await Provider.of<BrandController>(Get.context!, listen: false)
        .getBrandList(reload);
    await Provider.of<ProductController>(Get.context!, listen: false)
        .getLatestProductList(1, reload: reload);
    await Provider.of<ProductController>(Get.context!, listen: false)
        .getFeaturedProductList('1', reload: reload);
    await Provider.of<FeaturedDealController>(Get.context!, listen: false)
        .getFeaturedDealList(reload);
    await Provider.of<ProductController>(Get.context!, listen: false)
        .getLProductList('1', reload: reload);
    await Provider.of<ProductController>(Get.context!, listen: false)
        .getRecommendedProduct();
    await Provider.of<NotificationController>(Get.context!, listen: false)
        .getNotificationList(1);
    if (Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()) {
      await Provider.of<ProfileController>(Get.context!, listen: false)
          .getUserInfo(Get.context!);
    }
  }
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashController>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel =
        Provider.of<SplashController>(context, listen: false).configModel;
    bool isGuestMode =
        !Provider.of<AuthController>(context, listen: false).isLoggedIn();

    List<String?> types = [
      getTranslated('new_arrival', context),
      getTranslated('top_product', context),
      getTranslated('best_selling', context),
      getTranslated('discounted_product', context)
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await HomePage.loadData(true);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).highlightColor,
                title: Image.asset(Images.logoWithNameImage, height: 35),
                actions: [
                  Consumer<WishListController>(
                    builder: (context, wishListController, _) {
                      final wishListCount =
                          wishListController.wishList?.length ?? 0;
                      return SquareButtonWidget(
                        image: Images.wishlist,
                        title: null,
                        height: 40,
                        width: 40,
                        imageSize: 24,
                        navigateTo: const WishListScreen(),
                        count: wishListCount,
                        hasCount: !isGuestMode && wishListCount > 0,
                        padding: EdgeInsets.zero,
                        imagePadding: const EdgeInsets.all(0),
                        borderRadius: 8.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        imageColor: Colors.white,
                        countRadius: 8.0,
                        countBackgroundColor: Colors.red,
                        countTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                ],
              ),
              SliverToBoxAdapter(
                child: Provider.of<SplashController>(context, listen: false)
                            .configModel!
                            .announcement!
                            .status ==
                        '1'
                    ? Consumer<SplashController>(
                        builder: (context, announcement, _) {
                        return (announcement.configModel!.announcement!
                                        .announcement !=
                                    null &&
                                announcement.onOff)
                            ? AnnouncementWidget(
                                announcement:
                                    announcement.configModel!.announcement)
                            : const SizedBox();
                      })
                    : const SizedBox(),
              ),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen())),
                      child: const Hero(
                          tag: 'search',
                          child: Material(child: SearchHomePageWidget())),
                    ),
                  )),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BannersWidget(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    const CategoryListWidget(isHomePage: true),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Consumer<FlashDealController>(
                        builder: (context, megaDeal, child) {
                      return megaDeal.flashDeal == null
                          ? const FlashDealShimmer()
                          : megaDeal.flashDealList.isNotEmpty
                              ? Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault),
                                    child: TitleRowWidget(
                                      title:
                                          getTranslated('flash_deal', context)
                                              ?.toUpperCase(),
                                      eventDuration: megaDeal.flashDeal != null
                                          ? megaDeal.duration
                                          : null,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const FlashDealScreenView()));
                                      },
                                      isFlash: true,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                                  Text(
                                      getTranslated(
                                              'hurry_up_the_offer_is_limited_grab_while_it_lasts',
                                              context) ??
                                          '',
                                      style: textRegular.copyWith(
                                          color: Provider.of<ThemeController>(
                                                      context,
                                                      listen: false)
                                                  .darkTheme
                                              ? Theme.of(context).hintColor
                                              : Theme.of(context).primaryColor,
                                          fontSize:
                                              Dimensions.fontSizeDefault)),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                                  const FlashDealsListWidget()
                                ])
                              : const SizedBox.shrink();
                    }),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Consumer<FeaturedDealController>(
                        builder: (context, featuredDealProvider, child) {
                      return featuredDealProvider.featuredDealProductList !=
                              null
                          ? featuredDealProvider
                                  .featuredDealProductList!.isNotEmpty
                              ? Column(
                                  children: [
                                    Stack(children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                      ),
                                      Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          child: TitleRowWidget(
                                            title:
                                                '${getTranslated('featured_deals', context)}',
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const FeaturedDealScreenView())),
                                          ),
                                        ),
                                        const FeaturedDealsListWidget(),
                                      ]),
                                    ]),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                  ],
                                )
                              : const SizedBox.shrink()
                          : const FindWhatYouNeedShimmer();
                    }),
                    Consumer<BannerController>(
                        builder: (context, footerBannerProvider, child) {
                      return footerBannerProvider.footerBannerList != null &&
                              footerBannerProvider.footerBannerList!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: SingleBannersWidget(
                                  bannerModel: footerBannerProvider
                                      .footerBannerList?[0]))
                          : const SizedBox();
                    }),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    const FeaturedProductWidget(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    // todo : set top auctions

                    Consumer<AddAuctionController>(
                      builder: (context, controller, child) {
                        return StreamBuilder<List<Auction>>(
                          stream: controller.getAllActiveAuctionsStream(
                              context, "active"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // return SizedBox(
                              //   height: 200, // Give it a fixed height
                              //   child: ListView.builder(
                              //     scrollDirection: Axis.horizontal,
                              //     itemBuilder: (context, index) {
                              //       return const AuctionShimmerItemWidget();
                              //     },
                              //   ),
                              // );
                              return const SizedBox();
                            } else {
                              List<Auction> auctions = snapshot.data!;
                              return auctions.isNotEmpty
                                  ? Column(
                                      children: [
                                        TitleRowWidget(
                                            title: getTranslated(
                                                'active_auction', context),
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        AuctionListScreen()))),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        SizedBox(
                                          height: 190, // Give it a fixed height
                                          child: HorizontalAuctionListView(
                                              auctions: auctions),
                                        ),
                                      ],
                                    )
                                  : const SizedBox();
                            }
                          },
                        );
                      },
                    ),

                    singleVendor
                        ? const SizedBox()
                        : Consumer<ShopController>(
                            builder: (context, topSellerProvider, child) {
                            return (topSellerProvider.sellerModel != null &&
                                    (topSellerProvider.sellerModel!.sellers !=
                                            null &&
                                        topSellerProvider
                                            .sellerModel!.sellers!.isNotEmpty))
                                ? TitleRowWidget(
                                    title: getTranslated('top_seller', context),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const AllTopSellerScreen(
                                                  title: 'top_stores',
                                                ))))
                                : const SizedBox();
                          }),
                    singleVendor
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: Dimensions.paddingSizeSmall),
                    singleVendor
                        ? const SizedBox()
                        : Consumer<ShopController>(
                            builder: (context, topSellerProvider, child) {
                            return (topSellerProvider.sellerModel != null &&
                                    (topSellerProvider.sellerModel!.sellers !=
                                            null &&
                                        topSellerProvider
                                            .sellerModel!.sellers!.isNotEmpty))
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeDefault),
                                    child: SizedBox(
                                        height: ResponsiveHelper.isTab(context)
                                            ? 170
                                            : 165,
                                        child: TopSellerView(
                                          isHomePage: true,
                                          scrollController: _scrollController,
                                        )))
                                : const SizedBox();
                          }),
                    const Padding(
                        padding: EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault),
                        child: RecommendedProductWidget()),
                    const Padding(
                        padding: EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault),
                        child: LatestProductListWidget()),
                    // if (configModel?.brandSetting == "1")
                    //   TitleRowWidget(
                    //     title: getTranslated('brand', context),
                    //     onTap: () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (_) => const BrandsView())),
                    //   ),
                    // SizedBox(
                    //     height: configModel?.brandSetting == "1"
                    //         ? Dimensions.paddingSizeSmall
                    //         : 0),
                    // if (configModel!.brandSetting == "1") ...[
                    //   const BrandListWidget(isHomePage: true),
                    //   const SizedBox(height: Dimensions.paddingSizeDefault),
                    // ],
                    const HomeCategoryProductWidget(isHomePage: true),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    const FooterBannerSliderWidget(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Consumer<ProductController>(
                        builder: (ctx, prodProvider, child) {
                      return Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        Dimensions.paddingSizeDefault,
                                        0,
                                        Dimensions.paddingSizeSmall,
                                        0),
                                    child: Row(children: [
                                      Expanded(
                                          child: Text(
                                              prodProvider.title == 'xyz'
                                                  ? getTranslated(
                                                      'new_arrival', context)!
                                                  : prodProvider.title!,
                                              style: titleHeader.copyWith(
                                                  color: Colors.white))),
                                      prodProvider.latestProductList != null
                                          ? PopupMenuButton(
                                              color: Colors.white,
                                              elevation: 10,
                                              padding: const EdgeInsets.all(0),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    value:
                                                        ProductType.newArrival,
                                                    child: Text(
                                                        getTranslated(
                                                                'new_arrival',
                                                                context) ??
                                                            '',
                                                        style: textRegular
                                                            .copyWith(
                                                          color: prodProvider
                                                                      .productType ==
                                                                  ProductType
                                                                      .newArrival
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        )),
                                                  ),
                                                  PopupMenuItem(
                                                    value:
                                                        ProductType.topProduct,
                                                    child: Text(
                                                        getTranslated(
                                                                'top_product',
                                                                context) ??
                                                            '',
                                                        style: textRegular
                                                            .copyWith(
                                                          color: prodProvider
                                                                      .productType ==
                                                                  ProductType
                                                                      .topProduct
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        )),
                                                  ),
                                                  PopupMenuItem(
                                                    value:
                                                        ProductType.bestSelling,
                                                    child: Text(
                                                        getTranslated(
                                                                'best_selling',
                                                                context) ??
                                                            '',
                                                        style: textRegular
                                                            .copyWith(
                                                          color: prodProvider
                                                                      .productType ==
                                                                  ProductType
                                                                      .bestSelling
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        )),
                                                  ),
                                                  PopupMenuItem(
                                                    value: ProductType
                                                        .discountedProduct,
                                                    child: Text(
                                                        getTranslated(
                                                                'discounted_product',
                                                                context) ??
                                                            '',
                                                        style: textRegular
                                                            .copyWith(
                                                          color: prodProvider
                                                                      .productType ==
                                                                  ProductType
                                                                      .discountedProduct
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        )),
                                                  ),
                                                ];
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                          .paddingSizeSmall)),
                                              child: const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      Dimensions
                                                          .paddingSizeExtraSmall,
                                                      Dimensions
                                                          .paddingSizeSmall,
                                                      Dimensions
                                                          .paddingSizeExtraSmall,
                                                      Dimensions
                                                          .paddingSizeSmall),
                                                  child: Icon(
                                                    Icons.menu,
                                                    color: Colors.white,
                                                  )),
                                              onSelected: (ProductType value) {
                                                if (value ==
                                                    ProductType.newArrival) {
                                                  Provider.of<ProductController>(
                                                          context,
                                                          listen: false)
                                                      .changeTypeOfProduct(
                                                          value, types[0]);
                                                } else if (value ==
                                                    ProductType.topProduct) {
                                                  Provider.of<ProductController>(
                                                          context,
                                                          listen: false)
                                                      .changeTypeOfProduct(
                                                          value, types[1]);
                                                } else if (value ==
                                                    ProductType.bestSelling) {
                                                  Provider.of<ProductController>(
                                                          context,
                                                          listen: false)
                                                      .changeTypeOfProduct(
                                                          value, types[2]);
                                                } else if (value ==
                                                    ProductType
                                                        .discountedProduct) {
                                                  Provider.of<ProductController>(
                                                          context,
                                                          listen: false)
                                                      .changeTypeOfProduct(
                                                          value, types[3]);
                                                }
                                                Provider.of<ProductController>(
                                                        context,
                                                        listen: false)
                                                    .getLatestProductList(1,
                                                        reload: true);
                                              },
                                            )
                                          : const SizedBox()
                                    ])),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall),
                                  child: ProductListWidget(
                                      isHomePage: false,
                                      productType: ProductType.newArrival,
                                      scrollController: _scrollController),
                                ),
                                const SizedBox(
                                    height: Dimensions.homePagePadding)
                              ]));
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
