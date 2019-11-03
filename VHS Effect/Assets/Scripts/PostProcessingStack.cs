using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
struct Effect
{
    public Material material;
    public bool disabled;
}


[ExecuteInEditMode]
public class PostProcessingStack : MonoBehaviour
{
    [SerializeField]
    private Effect[] effects;


    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (effects.Length == 0)
        {
            Graphics.Blit(source, destination);
        }
        else if (effects.Length == 1)
        {
            ApplyEffect(source, destination, 0);
        }
        else
        {
            RenderTexture temp1 = RenderTexture.GetTemporary(source.descriptor);
            ApplyEffect(source, temp1, 0);
            for (int i = 1; i < effects.Length - 1; i++)
            {
                RenderTexture temp2 = RenderTexture.GetTemporary(source.descriptor);
                ApplyEffect(temp1, temp2, i);
                RenderTexture.ReleaseTemporary(temp1);
                temp1 = temp2;
            }
            ApplyEffect(temp1, destination, effects.Length - 1);
            RenderTexture.ReleaseTemporary(temp1);
        }
    }


    private void ApplyEffect(RenderTexture source, RenderTexture dest, int effectIndex)
    {
        if (effects[effectIndex].material == null || effects[effectIndex].disabled)
        {
            Graphics.Blit(source, dest);
        }
        else
        {
            Graphics.Blit(source, dest, effects[effectIndex].material);
        }
    }
}
