import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movies/colors/colors_theme.dart';
import 'package:movies/utilities/device_info.dart';
import 'package:movies/utilities/utilities.dart';
import 'package:movies/data_manager/data_manager.dart';
import 'package:movies/models/providers/provider_search.dart';
import 'package:provider/provider.dart';
import 'grid_view_search/grid_view_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  DataManager dataManager = DataManager();
  DeviceInfo deviceInfo = DeviceInfo();
  bool _isIPhoneNotch = false;

  Future<void> _getDeviceInfo() async {
    _isIPhoneNotch = await deviceInfo.isIPhoneNotch();
  }

  final ButtonStyle _searchButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: ColorSelect.customBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  updateSearchText(ProviderSearch searchProvider) {
    searchProvider.updateSearchText(_searchController.text);
  }

  _discoverItems(ProviderSearch searchProvider, bool forceRefresh) async {
    final Box<dynamic> _dataBox = Hive.box<dynamic>("dataBox");
    List<dynamic> newDiscoverItems = [];
    if (forceRefresh == false && _dataBox.get("discover") != null) {
      newDiscoverItems =
          Utilities.fromHiveToDataGenericItem(_dataBox.get("discover"));
    } else {
      newDiscoverItems =
          await dataManager.getDiscover(searchProvider.dropdownValue);
      String timestamp = DateTime.now().toIso8601String();
      await _dataBox.put("last_timestamp", timestamp);
      await _dataBox.put(
          "discover", Utilities.fromDataToHiveGenericItem(newDiscoverItems));
    }
    searchProvider.updateSearchedItems(newDiscoverItems);
    searchProvider.updateIsSearch(false);
    searchProvider.updateLoader(false);
  }

  _searchItems(ProviderSearch searchProvider) async {
    if (searchProvider.searchText != "") {
      searchProvider.updateLoader(true);
      List<dynamic> newSearchedItems =
          await dataManager.search(searchProvider.searchText);
      searchProvider.updateSearchedItems(newSearchedItems);
      searchProvider.updateIsSearch(true);
      searchProvider.updateLoader(false);
    }
  }

  // _filterClick(ProviderSearch searchProvider) {
  //   searchProvider.updateLoader(true);
  //   _searchController.text = "";
  //   searchProvider.updateSearchText("");
  //   searchProvider.updateLoader(false);
  // }

  Future<void> _pullRefresh(ProviderSearch searchProvider) async {
    _discoverItems(searchProvider, true);
  }

  @override
  void initState() {
    ProviderSearch searchProvider =
        Provider.of<ProviderSearch>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _discoverItems(searchProvider, false);
    });
    _getDeviceInfo();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // final Box<dynamic> _dataBox = Hive.box<dynamic>("dataBox");
    // _dataBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textPadding = 105;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      if (_isIPhoneNotch) {
        textPadding = 70;
      } else {
        textPadding = 50;
      }
    } else {
      if (_isIPhoneNotch) {
        textPadding = 115;
      }
    }

    return Consumer<ProviderSearch>(builder: (context, searchProvider, child) {
      return SingleChildScrollView(
          child: Column(children: [
        Padding(padding: EdgeInsets.only(top: textPadding)),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text("Discover", style: TextStyle(fontSize: 20)))),
        Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: TextField(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
              ),
              keyboardType: TextInputType.text,
              controller: _searchController,
              onChanged: (text) {
                if (text == "") {
                  _discoverItems(searchProvider, false);
                } else {
                  updateSearchText(searchProvider);
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: ColorSelect.customBlue, width: 3.0)),
                  contentPadding: const EdgeInsets.only(
                      left: 10, top: 5, right: 10, bottom: 5),
                  hintText: "Search",
                  hintStyle:
                      const TextStyle(color: Colors.black54, fontSize: 18),
                  filled: true,
                  fillColor: Colors.white),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: _searchButtonStyle,
                    onPressed: () => _searchItems(searchProvider),
                    child: const Text("Search")))),
        Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: searchProvider.dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                      color: ColorSelect.customBlue, fontSize: 18),
                  onChanged: (String? newValue) {
                    searchProvider.updateDropdownValue(newValue!);
                    _discoverItems(searchProvider, true);
                    _searchController.text = "";
                  },
                  items: <String>['Movie', 'TV serie']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ))),
        searchProvider.isSearch
            ? const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Text("Results", style: TextStyle(fontSize: 20))))
            : Container(),
        RefreshIndicator(
            onRefresh: () => _pullRefresh(searchProvider),
            child: const GridViewSearch())
      ]));
    });
  }
}
