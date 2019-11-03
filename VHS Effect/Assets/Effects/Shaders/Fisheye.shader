Shader "Image Effects/Fisheye"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_WarpAmount("Warp Amount", Float) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float _WarpAmount;

            fixed4 frag (v2f i) : SV_Target
            {
				float2 warpedUV = float2(
					i.uv.x + pow(i.uv.y - 0.5, 2) * (i.uv.x - 0.5) * _WarpAmount * _ScreenParams.y / _ScreenParams.x,
					i.uv.y + pow(i.uv.x - 0.5, 2) * (i.uv.y - 0.5) * _WarpAmount);
				return (warpedUV.x < 0 || warpedUV.y < 0 || warpedUV.x > 1 || warpedUV.y > 1) ? fixed4(0, 0, 0, 1) : tex2D(_MainTex, warpedUV);
            }
            ENDCG
        }
    }
}
