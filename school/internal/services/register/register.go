package register

import (
	"encoding/json"
	"fmt"
	"net"
	"time"
)

type RegisterRequest struct {
	Type    string `json:"type"`
	Address string `json:"address"`
}

type RegisterResponse struct {
	Status int `json:"status"`
}

type ServiceRequest struct {
	Type string `json:"type"`
}

type ServiceResponse struct {
	Services []string `json:"services"`
	Status   int      `json:"status"`
}

type SvcDiscoveryClient struct {
	SDUrl string
	Conn  net.Conn
}

func NewSvcDiscoveryClient(SDUrl string) (*SvcDiscoveryClient, error) {

	conn, err := net.Dial("tcp", SDUrl)
	if err != nil {
		fmt.Println("Error connecting:", err)
		return nil, err
	}

	conn.SetDeadline(time.Time{})

	return &SvcDiscoveryClient{
		SDUrl: SDUrl,
		Conn:  conn,
	}, nil
}

func (c *SvcDiscoveryClient) Register(serviceType string, serviceAddress string) error {
	request := RegisterRequest{
		Type:    serviceType,
		Address: serviceAddress,
	}

	bytes, err := json.Marshal(request)
	if err != nil {
		return err
	}
	_, err = c.Conn.Write(bytes)
	return err
}
