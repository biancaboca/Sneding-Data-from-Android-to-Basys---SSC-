package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Handler;
import android.view.View;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ImageButton;
import android.widget.TextView;

public class SecondActivity extends AppCompatActivity {
    MainActivity main = new MainActivity();
    TextView texting2;
    StringBuilder sb=new StringBuilder();
    private BluetoothAdapter bAdapter = BluetoothAdapter.getDefaultAdapter();
    Handler handler=new Handler();
    Runnable updater;
    @SuppressLint("MissingInflatedId")

    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.second_activity);

        ImageButton back = (ImageButton) findViewById(R.id.imageButtonReturn);
        texting2 = (TextView) findViewById(R.id.editTextTextPersonName2);


        updater=new Runnable() {
            @Override
            public void run() {
                texting2.append(main.receive());
                handler.postDelayed(updater,1000);

            }
        };
        handler.post(updater);

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(SecondActivity.this, MainActivity
                        .class);
                startActivity(intent);

            }
        });

    }

}