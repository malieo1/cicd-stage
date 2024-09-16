<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class HelloWorldControllerTest extends WebTestCase
{
    public function testIndex()
    {
        // Create a client to make requests
        $client = static::createClient();

        // Make a request to the root route (empty path)
        $crawler = $client->request('GET', '/');

        // Assert that the response is successful
        $this->assertResponseIsSuccessful();

        // Assert that the response content contains the updated text
        $this->assertSelectorTextContains('h1', 'Did you like our project?');
        $this->assertSelectorExists('button#yes-button');
        $this->assertSelectorExists('button#no-button');
    }
}
