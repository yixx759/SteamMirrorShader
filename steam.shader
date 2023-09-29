Shader "Unlit/steam"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _side ("side", 2D) = "white" {}
        _reflection ("reflection", 2D) = "white" {}
        _1col ("Col1", Color)=(1,1,1,1)
        _2col ("Col2", Color)= (1,0,0,1)
        _tr ("size", float)= 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            // make fog work
      
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 nuuv : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _side;
            sampler2D _reflection;
            float4 _MainTex_ST;
            float4 _side_ST;
            float4 _reflection_ST;
            float4 _1col;
            float4 _2col;
            float _tr;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv = TRANSFORM_TEX(v.uv, _side);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float4 _1reflection = tex2D(_reflection ,i.uv);
                // sample the texture
                half col = tex2D(_MainTex, i.uv);
                //float4 col5 = tex2D(_MainTex, i.uv);
                half col5 = tex2D(_side, i.uv);
                
                

                
                  return lerp(lerp( _1reflection,_1col, col5), _1reflection, col);
                //col1 = lerp(_1col, _2col, col5);
            }
            ENDCG
        }
    }
}
