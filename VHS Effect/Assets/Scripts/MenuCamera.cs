using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuCamera : MonoBehaviour
{
    [SerializeField]
    private float period = 8;
    [SerializeField]
    private float pitchAngle = 3;
    [SerializeField]
    private float yawAngle = 20;

    private Quaternion initialRotation;

    // Start is called before the first frame update
    void Start()
    {
        initialRotation = transform.localRotation;
    }

    // Update is called once per frame
    void Update()
    {
        transform.localRotation = initialRotation * Quaternion.Euler(Mathf.Cos(Time.time / period * Mathf.PI) * pitchAngle, Mathf.Sin(Time.time / period * Mathf.PI) * yawAngle, 0);
    }
}
