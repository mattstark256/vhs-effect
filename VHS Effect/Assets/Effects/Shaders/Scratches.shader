Shader "Image Effects/Scratches"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ScratchTex("Scratch Texture", 2D) = "white" {}

		_Speed("Speed", Float) = 1
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
			sampler2D _ScratchTex;
			float _Speed;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_ScratchTex, float2(_Time[1] * _Speed, i.uv.y));
				col = lerp(col, fixed4(1, 1, 1, 1), col2.r);
                // just invert the colors
                //col.rgb = 1 - col.rgb;
                return col;
            }
            ENDCG
        }
    }
}
