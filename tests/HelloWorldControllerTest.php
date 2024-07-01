<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class HelloWorldControllerTest extends WebTestCase
{
    public function testIndex()
    {
        // Create a client to make requests
        $client = static::createClient();

        // Make a request to the /hello/world route
        $crawler = $client->request('GET', '/hello/world');

        // Assert that the response is successful
        $this->assertResponseIsSuccessful();

        // Assert that the response content contains "Hello, World!"
        $this->assertSelectorTextContains('body', 'Hello, World!');
    }
}