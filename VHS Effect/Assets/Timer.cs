using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Text))]
public class Timer : MonoBehaviour
{
    private Text text;

    private void Awake()
    {
        text = GetComponent<Text>();
    }

    void Update()
    {
        int seconds = Mathf.FloorToInt(Time.time) % 60;
        int minutes = Mathf.FloorToInt(Time.time / 60) % 60;
        text.text = "0:" + minutes.ToString("00") + ":" + seconds.ToString("00");
    }
}
