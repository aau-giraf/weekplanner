/* 
 * My API
 *
 * No description provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)
 *
 * OpenAPI spec version: v1
 * 
 * Generated by: https://github.com/swagger-api/swagger-codegen.git
 */

using System;
using System.IO;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reflection;
using RestSharp;
using NUnit.Framework;

using IO.Swagger.Client;
using IO.Swagger.Api;
using IO.Swagger.Model;

namespace IO.Swagger.Test
{
    /// <summary>
    ///  Class for testing ErrorApi
    /// </summary>
    /// <remarks>
    /// This file is automatically generated by Swagger Codegen.
    /// Please update the test case below to test the API endpoint.
    /// </remarks>
    [TestFixture]
    public class ErrorApiTests
    {
        private ErrorApi instance;

        /// <summary>
        /// Setup before each unit test
        /// </summary>
        [SetUp]
        public void Init()
        {
            instance = new ErrorApi();
        }

        /// <summary>
        /// Clean up after each unit test
        /// </summary>
        [TearDown]
        public void Cleanup()
        {

        }

        /// <summary>
        /// Test an instance of ErrorApi
        /// </summary>
        [Test]
        public void InstanceTest()
        {
            // TODO uncomment below to test 'IsInstanceOfType' ErrorApi
            //Assert.IsInstanceOfType(typeof(ErrorApi), instance, "instance is a ErrorApi");
        }

        
        /// <summary>
        /// Test V1ErrorGet
        /// </summary>
        [Test]
        public void V1ErrorGetTest()
        {
            // TODO uncomment below to test the method and replace null with proper value
            //int? status = null;
            //var response = instance.V1ErrorGet(status);
            //Assert.IsInstanceOf<Response> (response, "response is Response");
        }
        
        /// <summary>
        /// Test V1ErrorPost
        /// </summary>
        [Test]
        public void V1ErrorPostTest()
        {
            // TODO uncomment below to test the method and replace null with proper value
            //int? status = null;
            //var response = instance.V1ErrorPost(status);
            //Assert.IsInstanceOf<Response> (response, "response is Response");
        }
        
    }

}
