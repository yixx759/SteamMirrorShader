using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.UIElements;
using Random = UnityEngine.Random;

public class Drawer : MonoBehaviour
{
    // Start is called before the first frame update

    public ComputeShader DrawShader;
    public RenderTexture t;
    public RenderTexture ta;
    public Texture tocomp;

    public Material change;
    // public RenderTexture t;

    private int kern;
    private int kern2;
    private int kern3;
    private int heigt, width;

    [SerializeField] private int thresh;

     private Vector3 pos;

     private int[] counter;

    
    private Vector3 screenpos;
    private Vector2 bounds;
    
    private ComputeBuffer ints;
    public Camera cam;

    private int[] zer;
    private Material stemy;
    
    
    private Vector3 globdist;
    private Vector3 nuglobdist;

    void Start()
    {
        ta = new RenderTexture(512, 512, 0,RenderTextureFormat.R8, RenderTextureReadWrite.Linear);
        ta.enableRandomWrite = true;
        Graphics.Blit(tocomp, ta);
        ta.Create();
        counter = new int [1];
        zer = new int [1];
        zer[0] = 0;
        ints = new ComputeBuffer(1, sizeof(int));
        
        
        //fade up
        change.SetFloat("_offsetx", Random.Range(0,20));
        change.SetFloat("_offsety", Random.Range(0,20));
        stemy = GetComponent<Renderer>().material;
        bounds = new Vector2(GetComponent<Renderer>().bounds.size.x, GetComponent<Renderer>().bounds.size.y);
        globdist = new Vector3(transform.position.x-bounds.x/2,transform.position.y - bounds.y/2, transform.position.z);
        nuglobdist = new Vector3(transform.position.x+bounds.x/2,transform.position.y + bounds.y/2, transform.position.z);
        
        
        t = new RenderTexture(512, 512, 0,RenderTextureFormat.R8, RenderTextureReadWrite.Linear);
        t.enableRandomWrite = true;
        t.Create();
        
        kern = DrawShader.FindKernel("CSMain");
        kern2 = DrawShader.FindKernel("Fader");
        kern3 = DrawShader.FindKernel("Comparer");
        heigt = (512 / 8);
        width= (512 / 8);
        DrawShader.SetInt("threshold" ,thresh);
        GetComponent<Renderer>().material.mainTexture = t;
        stemy.SetTexture("_MainTex" ,t );
        
        

    }

     //Update is called once per frame
     void FixedUpdate()
     {
         ints.SetData(zer);
         DrawShader.SetTexture(kern2,"Result",t);
         
         DrawShader.Dispatch(kern2, heigt, width, 1);
         
         DrawShader.SetTexture(kern3,"Result",t);
         DrawShader.SetTexture(kern3,"Tocompare",ta);
         DrawShader.SetBuffer(kern3,"count",ints);
         DrawShader.Dispatch(kern3, heigt, width, 1);

         ints.GetData(counter);
         
         print(counter[0]);
       
         
     }

     private void Update()
     {
        
     }


     private void OnMouseDown()
     {
         //-6.13  -0.7  0.27 0.38571428571428571428571428571429
         //-6.4 true neutral
     }

     private void OnMouseDrag()
     {
         screenpos = Input.mousePosition;
         screenpos.z = cam.nearClipPlane +2;
         
        
         Vector3 slapdash = cam.WorldToScreenPoint(globdist);
         Vector3 nuslapdash = cam.WorldToScreenPoint(nuglobdist);
         slapdash.x  =slapdash.x/Screen.width;
         slapdash.y  =slapdash.y/Screen.height;
         
         nuslapdash.x  =nuslapdash.x/Screen.width;
         nuslapdash.y  =nuslapdash.y/Screen.height;
        
         
         Vector3 slaperdash = screenpos;
         slaperdash.x /= Screen.width;
         slaperdash.y /= Screen.height;

         slaperdash.x = Mathf.InverseLerp(slapdash.x, nuslapdash.x, slaperdash.x);
         slaperdash.y = Mathf.InverseLerp(slapdash.y, nuslapdash.y, slaperdash.y);
         
        
         pos = slaperdash;
         pos.x *= (512);
         pos.y *= (512);
         
        
        
         Vector2 newt = new Vector2(pos.x, pos.y);

         DrawShader.SetVector("muspos", newt );
         
         DrawShader.SetTexture(kern,"Result",t);
         DrawShader.Dispatch(kern, heigt, width, 1);
     }
 }
