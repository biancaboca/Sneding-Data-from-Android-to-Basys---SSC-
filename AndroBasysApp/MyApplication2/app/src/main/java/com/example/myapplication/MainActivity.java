package com.example.myapplication;
import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.UUID;
import java.util.logging.Logger;
public class MainActivity extends AppCompatActivity {
    private ImageButton imageButton;
    EditText texting;
    private Button starting;
    int MY_PERMISSION_ACCESS_COARSE_LOCATION = 100;
    BluetoothAdapter bltA;
    int Request_Enable_Bt = 1;
    private BluetoothSocket mBTSocket = null; // bi-directional client-to-client data path
    OutputStream out = null;
    static InputStream input = null;
    InputStreamReader aReader = null;
    private BufferedReader mBufferedReader = null;
    BluetoothDevice device;
    int read;
    byte[] buffer;
    String array;
    TextView texting2;
    Runnable updater;
    String gettinText;
    Handler handler;
    Bundle intentExtras;



    @SuppressLint({"MissingInflatedId", "MissingPermission"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //cream action bar


        ActionBar actionBar;
        actionBar = getSupportActionBar();
        ColorDrawable color;
        color = new ColorDrawable(Color.parseColor("#4549C6"));
        actionBar.setBackgroundDrawable(color);

        actionBar.setTitle("Andro Basys");
        //cream buton pt o noua interfata
        imageButton = (ImageButton) findViewById(R.id.imageButtonBack);
        Button buttonOFF = (Button) findViewById(R.id.TurnOFF);
        Button buttonON = (Button) findViewById(R.id.turnIn);
        starting = (Button) findViewById(R.id.START);
        texting = (EditText) findViewById(R.id.editTextTextPersonName);
        texting2 = (TextView) findViewById(R.id.textView2);



        imageButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MainActivity.this, SecondActivity.class);
                startActivity(intent);
            }
        });
        bltA = BluetoothAdapter.getDefaultAdapter();
        if (bltA == null) {
            finish();
        }
        if (!bltA.isEnabled()) {
            Intent enableBlt = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBlt, Request_Enable_Bt);
        }
        final UUID SerialUUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");
        String mac ="16:C4:01:00:81:82";
        device = bltA.getRemoteDevice(mac);
        try {
//            mBTSocket = device.createRfcommSocketToServiceRecord(SerialUUID);
            mBTSocket = (BluetoothSocket) device.getClass().getMethod("createRfcommSocket", new Class[]{int.class}).invoke(device, 1);
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        InputStream INPUT = null;
        try {
            if(mBTSocket!=null) {
                mBTSocket.connect();
            }
            out = mBTSocket.getOutputStream();
            input = mBTSocket.getInputStream();
            aReader = new InputStreamReader(input);
            mBufferedReader = new BufferedReader(aReader);
        } catch (IOException e) {
            e.printStackTrace();
        }

        final BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.BLUETOOTH_CONNECT}, 100);
        }

        buttonON.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("MissingPermission")
            @Override
            public void onClick(View v) {
                if (bluetoothAdapter == null) {
                    Toast.makeText(getApplicationContext(), "Bluetooth Not Supported", Toast.LENGTH_SHORT).show();
                } else {
                    if (!bluetoothAdapter.isEnabled()) {
                        startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 1);
                        Toast.makeText(getApplicationContext(), "Bluetooth Turned ON", Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

        buttonOFF.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("MissingPermission")
            @Override
            public void onClick(View v) {
                bluetoothAdapter.disable();
                Toast.makeText(getApplicationContext(), "Bluetooth Turned OFF", Toast.LENGTH_SHORT).show();
            }
        });


        starting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String textFromEditText = texting.getText().toString();
                if (textFromEditText.length() > 4) {
                    Toast.makeText(getApplicationContext(), "Too much charachters", Toast.LENGTH_SHORT).show();
                } else if (textFromEditText.length() < 4) {
                    String deConcatenat = "____";
                    textFromEditText = textFromEditText.concat(deConcatenat.substring(0, (4 - textFromEditText.length())));
                    Toast.makeText(getApplicationContext(), textFromEditText, Toast.LENGTH_LONG).show();
                    for (int i = 0; i < textFromEditText.length(); i++) {
                        String c = String.valueOf(textFromEditText.charAt(i));
                        buffer = c.getBytes(StandardCharsets.UTF_8);
                        writing(buffer);
                    }
                } else if (textFromEditText.length() == 4) {
                    for (int i = 0; i < textFromEditText.length(); i++) {
                        String c = String.valueOf(textFromEditText.charAt(i));
                        buffer = c.getBytes(StandardCharsets.UTF_8);
                        writing(buffer);
                    }
                }
            }
        });
    }



    public void writing(byte[] bytes) {
        try {
            out.write(bytes);
        } catch (IOException e) {
        }
    }


    public String receive() {
        byte[] buffer = new byte[1024];

        ByteArrayInputStream arrays=new ByteArrayInputStream(buffer);
        try {
            read = input.read(buffer); //numarul de biti
            array = String.valueOf((char) arrays.read());

        } catch (IOException e) {
            e.printStackTrace();

        }

        return array;
    }

}



