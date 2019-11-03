using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    private Transform head;
    [SerializeField]
    private float mouseSensitivity = 3;
    [SerializeField]
    private float maxAcceleration = 3;
    [SerializeField]
    private float maxSpeed = 3;

    private float yaw;
    private float pitch;

    private Vector3 moveVelocity = Vector3.zero;


    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

        yaw = head.eulerAngles.y;
        pitch = head.eulerAngles.x;
    }


    void Update()
    {
        Vector2 mouseVector = new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y"));
        mouseVector *= mouseSensitivity;
        yaw += mouseVector.x;
        if (!Input.GetKey(KeyCode.Space)) pitch -= mouseVector.y;
        head.rotation = Quaternion.Euler(pitch, yaw, 0);

        Vector3 inputVector = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical"));
        Vector3 targetVelocity = head.rotation * inputVector.normalized * maxSpeed;

        if (Input.GetKey(KeyCode.LeftShift)) targetVelocity *= 5;

        Vector3 amountToAccelerate = targetVelocity - moveVelocity;
        if (amountToAccelerate.magnitude > maxAcceleration * Time.deltaTime) { amountToAccelerate = amountToAccelerate.normalized * maxAcceleration * Time.deltaTime; }
        moveVelocity += amountToAccelerate;

        transform.position += moveVelocity * Time.deltaTime;
    }
}
