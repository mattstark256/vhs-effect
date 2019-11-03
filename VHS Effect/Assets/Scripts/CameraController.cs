using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
// There's some issue with unity_CameraToWorld and ImageEffectAllowedInSceneView
//[ImageEffectAllowedInSceneView]
public class CameraController : MonoBehaviour
{
    [SerializeField]
    private Material fisheyeMaterial;


    private Camera cam;
    public Camera Cam
    {
        get
        {
            if (!cam)
            {
                cam = GetComponent<Camera>();
            }
            return cam;
        }
    }


    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (!fisheyeMaterial)
        {
            Graphics.Blit(source, destination);
            return;
        }

        // Get the view frustum dimensions with a depth of 1
        float frustumHeight = 2 * Mathf.Tan(Cam.fieldOfView * 0.5f * Mathf.Deg2Rad);
        float frustumWidth = frustumHeight * Cam.aspect;
        
        fisheyeMaterial.SetFloat("_FrustumWidth", frustumWidth);
        fisheyeMaterial.SetFloat("_FrustumHeight", frustumHeight);

        Graphics.Blit(source, destination, fisheyeMaterial);
    }
}
