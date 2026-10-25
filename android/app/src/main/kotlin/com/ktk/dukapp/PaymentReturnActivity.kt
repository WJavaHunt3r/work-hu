package com.ktk.dukapp

import android.app.Activity
import android.content.Intent
import android.os.Bundle

// Receives dukapp://app/<route> from the payment return page (web/payment-return.html) in the Chrome Custom Tab and
// hands it to MainActivity with CLEAR_TOP, which closes the tab above it; Flutter then opens the route. MainActivity
// keeps its singleTop launch mode, so nothing else changes.
class PaymentReturnActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startActivity(
            Intent(this, MainActivity::class.java)
                .setAction(Intent.ACTION_VIEW)
                .setData(intent?.data)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        )
        finish()
    }
}
