import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/home/buy_ticket_controller.dart';
import '../../../models/user/home/ticket_purchase_model.dart';


class BuyTicketScreen extends StatefulWidget {
  final String eventId;
  const BuyTicketScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  int ticketCount = 1;
  Set<int> sameAsBeforeIndices = {};
  
  // Lists to store controllers for each ticket form
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> idControllers = [];
  List<String> selectedIdTypes = [];

  final BuyTicketController controller = Get.put(BuyTicketController());

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // disposse existing if any or just clear and rebuild
    // For simplicity, we'll sync list length with ticketCount
    _syncControllers();
  }

  void _syncControllers() {
    if (nameControllers.length < ticketCount) {
      for (int i = nameControllers.length; i < ticketCount; i++) {
        nameControllers.add(TextEditingController());
        idControllers.add(TextEditingController());
        selectedIdTypes.add('Passport');
      }
    } else if (nameControllers.length > ticketCount) {
      for (int i = nameControllers.length; i > ticketCount; i--) {
        nameControllers.last.dispose();
        nameControllers.removeLast();
        idControllers.last.dispose();
        idControllers.removeLast();
        selectedIdTypes.removeLast();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in idControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handlePurchase() {
    if (nameControllers.any((c) => c.text.isEmpty) ||
        idControllers.any((c) => c.text.isEmpty)) {
      Get.snackbar("Error", "Please fill all fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    List<TicketOwner> owners = [];
    for (int i = 0; i < ticketCount; i++) {
      owners.add(TicketOwner(
        name: nameControllers[i].text,
        identificationType: selectedIdTypes[i],
        identificationNumber: idControllers[i].text,
      ));
    }

    controller.purchaseTicket(widget.eventId, ticketCount, owners);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(title: "Buy Ticket"),
      body: Obx(() => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Number of ticket",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCounterButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (ticketCount > 1) {
                            setState(() {
                              ticketCount--;
                              _syncControllers();
                            });
                          }
                        },
                        color: Color(0xFF1B5E4E),
                      ),
                      Container(
                        width: 150.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Color(0xFF1B5E4E)),
                        ),
                        child: Text(
                          ticketCount.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B5E4E),
                          ),
                        ),
                      ),
                      _buildCounterButton(
                        icon: Icons.add,
                        onTap: () {
                          if (ticketCount < 10) { // Limit max tickets if needed
                            setState(() {
                              ticketCount++;
                              _syncControllers();
                            });
                          }
                        },
                        color: Color(0xFF1B5E4E),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  // Ticket Forms
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ticketCount,
                    separatorBuilder: (context, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      return _buildTicketForm(index);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Section
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : _handlePurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1B5E4E),
                elevation: 0,
                minimumSize: Size(double.infinity, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      "Purchase Now",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildCounterButton({required IconData icon, required VoidCallback onTap, required Color color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildTicketForm(int index) {
    bool isFirst = index == 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFirst) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
                GestureDetector(
                onTap: () {
                  setState(() {
                    if (sameAsBeforeIndices.contains(index)) {
                      sameAsBeforeIndices.remove(index);
                    } else {
                      sameAsBeforeIndices.add(index);
                      // Copy specific logic from previous index
                      if(index > 0) {
                         nameControllers[index].text = nameControllers[index-1].text;
                         idControllers[index].text = idControllers[index-1].text;
                         selectedIdTypes[index] = selectedIdTypes[index-1];
                      }
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      sameAsBeforeIndices.contains(index) ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: Color(0xFF1B5E4E),
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Same as before",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1B5E4E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ticket owner name",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: nameControllers[index],
                decoration: InputDecoration(
                  hintText: "Enter name",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E), width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Select ID Type",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: selectedIdTypes[index],
                items: ['Passport', 'NID', 'Driving License']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, style: TextStyle(fontSize: 12.sp)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedIdTypes[index] = value!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E), width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Identification number",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: idControllers[index],
                decoration: InputDecoration(
                  hintText:  "*****************" ,
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFF1B5E4E), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
