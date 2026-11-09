# NovaWallet — Modern Digital Wallet & FinTech Platform

**Modern Responsive FinTech Digital Wallet Application Built with Flutter Web**  
* **Application Category:** Digital Wallet & Peer-to-Peer Payments  
* **Demo Account Profile:** Aarav Mehta (`NV-849201`)  
* **Live Web App:** [https://dannyprajwal2028.github.io/ui_flutter/](https://dannyprajwal2028.github.io/ui_flutter/)  
* **Repository:** [https://github.com/DannyPrajwal2028/ui_flutter](https://github.com/DannyPrajwal2028/ui_flutter)  

---

## 📌 Project Overview
**NovaWallet** is a full-featured, responsive FinTech digital wallet web application engineered with Flutter Web. It provides users with instant peer-to-peer money transfers, virtual card management, wallet balance controls, category-based transaction history, and detailed payment receipt inspection.

Designed following modern Material 3 FinTech principles, it strictly fulfills all 7 laboratory evaluation rubric criteria.

---

## 🎯 Evaluation Rubric Checklist & Implementation Details

| No. | Lab Requirement | How It Is Implemented in NovaWallet |
| :--- | :--- | :--- |
| **1** | **Different Widgets** | Extensive use of `Container`, `Stack` (virtual card layers, chip, and frozen state overlay), `Card`, `Row`, `Column`, `ListView`, `GridView`, `ChoiceChip`, `ActionChip`, `Slider`, `ElevatedButton`, `OutlinedButton`, `IconButton`, `TextFormField`, `DropdownButtonFormField`, `SwitchListTile`, and `ModalBottomSheet`. |
| **2** | **Responsive UI Design** | Uses `LayoutBuilder` and `MediaQuery`. Smoothly adapts to:<br>• **Mobile (< 840px):** Single-column layout with quick action buttons and bottom `NavigationBar`.<br>• **Tablet & Desktop (>= 840px):** Expanded FinTech dashboard with persistent side `NavigationRail` and multi-column transaction / card panels. |
| **3** | **Navigation** | Multi-screen routing via `Navigator` and bottom/rail destinations across:<br>• **Wallet Dashboard Screen**<br>• **Send Money / Transfer Screen**<br>• **Add Funds Top-up Screen**<br>• **Virtual Cards & Limits Screen**<br>• **Transaction Receipt Modal Bottom Sheet**<br>• **Viva Profile & Checklist Screen** |
| **4** | **Animations** | Interactive animations including eye icon show/hide balance toggle, dynamic card freeze overlay, choice chip selection animations, and receipt modal slide-ups. |
| **5** | **State Management** | Centralized with `Provider` (`ChangeNotifierProvider` & `Consumer`):<br>• Live balance update on Send / Top-up<br>• Instant card freeze/unfreeze toggle<br>• Real-time search query filtering<br>• Category-based transaction filtering |
| **6** | **Themes & Custom Widgets** | Complete **Dark Mode & Light Mode** toggle with custom `AppTheme`, custom reusable `VirtualCardWidget`, `TransactionTile`, and rubric verification components. |
| **7** | **Forms & Validation** | Robust transfer and top-up forms using `GlobalKey<FormState>`:<br>• **Recipient Name:** Minimum 3 characters check.<br>• **UPI ID / Mobile:** Regex check for valid UPI format (`user@bank`) or 10-digit phone number.<br>• **Transfer Amount:** Numeric validation, must be > 0, and strictly cannot exceed available wallet balance.<br>• **Top-up Amount:** Range check (min ₹50 to max ₹1,00,000). |

---

## 💡 Key Features

1. **Wallet Balance Management**:
   - Total wallet balance with privacy eye toggle (hide/show balance).
   - Monthly income vs monthly expense metric pills.
2. **Instant Fund Transfers**:
   - Send money to friends via UPI ID or phone number with real-time balance boundary checks.
   - 1-tap quick send to frequent contacts.
   - Category tagging (Food, Transfers, Shopping, Bills, Entertainment).
3. **Virtual Debit / Credit Cards**:
   - Realistic gradient cards with EMV chip, contactless symbol, and masked card numbers.
   - Interactive Freeze/Unfreeze card toggle.
   - Daily spending limit slider and e-commerce toggles.
4. **Transaction History & Detailed Receipts**:
   - Filter transactions by category or search by merchant/recipient.
   - Interactive receipt modal with transaction ID, timestamp, and status.
5. **Examiner & Viva Dashboard**:
   - Dedicated Viva screen showcasing rubric compliance and student identity details.

---

## 🛠️ How to Run Locally

```bash
# 1. Clone repository
git clone https://github.com/DannyPrajwal2028/ui_flutter.git
cd ui_flutter

# 2. Get dependencies
flutter pub get

# 3. Run on Chrome
flutter run -d chrome
```

---

## 🚀 Deployment (GitHub Pages)

The project includes an automated GitHub Actions CI/CD workflow (`.github/workflows/deploy.yml`):
* Every commit pushed to `main` automatically runs tests, builds the web bundle (`flutter build web --release --base-href /ui_flutter/`), and deploys directly to **GitHub Pages**.
* **Live Deployment URL:** [https://dannyprajwal2028.github.io/ui_flutter/](https://dannyprajwal2028.github.io/ui_flutter/)
