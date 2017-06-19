package com.dpu.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.codehaus.jackson.map.annotate.JsonSerialize;
import org.codehaus.jackson.map.annotate.JsonSerialize.Inclusion;

@Entity
@Table(name = "shippermaster")
@JsonSerialize(include = Inclusion.NON_NULL)
public class Shipper {

	@Id
	@Column(name = "shipper_id")
	//@JsonProperty(value = "shipper_id")
	@GeneratedValue
	private Long shipperId;

	@Column(name = "location_name")
	private String locationName;

	@Column(name = "Address")
	//@JsonProperty(value = "address")
	private String address;

	@Column(name = "unit")
	//@JsonProperty(value = "unit")
	private String unit;

	@Column(name = "city")
	//@JsonProperty(value = "city")
	private String city;

	@Column(name = "prov_state")
	//@JsonProperty(value = "province_state")
	private String provinceState;

	@Column(name = "postal_zip")
	//@JsonProperty(value = "postal_zip")
	private String postalZip;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "status_id")
	private Status status;

	@Column(name = "zone")
	//@JsonProperty(value = "zone")
	private String zone;

	@Column(name = "lead_time")
	//@JsonProperty(value = "lead_time")
	private String leadTime;

	@Column(name = "time_zone")
	//@JsonProperty(value = "time_zone")
	private String timeZone;

	@Column(name = "contact")
	//@JsonProperty(value = "contact")
	private String contact;

	@Column(name = "position")
	//@JsonProperty(value = "position")
	private String position;

	@Column(name = "phone")
	//@JsonProperty(value = "phone")
	private String phone;

	@Column(name = "ext")
	//@JsonProperty(value = "ext")
	private String ext;

	@Column(name = "fax")
	//@JsonProperty(value = "fax")
	private String fax;

	@Column(name = "shipper_prefix")
	//@JsonProperty(value = "prefix")
	private String prefix;

	@Column(name = "toll_free")
	//@JsonProperty(value = "toll_free")
	private String tollFree;

	@Column(name = "plant")
	//@JsonProperty(value = "plant")
	private String plant;

	@Column(name = "email")
	//@JsonProperty(value = "email")
	private String email;

	@Column(name = "importer")
	//@JsonProperty(value = "importer")
	private String importer;

	@Column(name = "internam_notes")
	//@JsonProperty(value = "internal_notes")
	private String internalNotes;

	@Column(name = "standard_notes")
	//@JsonProperty(value = "standard_notes")
	private String standardNotes;

	public Long getShipperId() {
		return shipperId;
	}

	public void setShipperId(Long shipperId) {
		this.shipperId = shipperId;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getProvinceState() {
		return provinceState;
	}

	public void setProvinceState(String provinceState) {
		this.provinceState = provinceState;
	}

	public String getPostalZip() {
		return postalZip;
	}

	public void setPostalZip(String postalZip) {
		this.postalZip = postalZip;
	}

	public String getZone() {
		return zone;
	}

	public void setZone(String zone) {
		this.zone = zone;
	}

	public String getLeadTime() {
		return leadTime;
	}

	public void setLeadTime(String leadTime) {
		this.leadTime = leadTime;
	}

	public String getTimeZone() {
		return timeZone;
	}

	public void setTimeZone(String timeZone) {
		this.timeZone = timeZone;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getExt() {
		return ext;
	}

	public void setExt(String ext) {
		this.ext = ext;
	}

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public String getTollFree() {
		return tollFree;
	}

	public void setTollFree(String tollFree) {
		this.tollFree = tollFree;
	}

	public String getPlant() {
		return plant;
	}

	public void setPlant(String plant) {
		this.plant = plant;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getImporter() {
		return importer;
	}

	public void setImporter(String importer) {
		this.importer = importer;
	}

	public String getInternalNotes() {
		return internalNotes;
	}

	public void setInternalNotes(String internalNotes) {
		this.internalNotes = internalNotes;
	}

	public String getStandardNotes() {
		return standardNotes;
	}

	public void setStandardNotes(String standardNotes) {
		this.standardNotes = standardNotes;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	// private String ReportName;
	// private String Report;
	// private String directions;
	// private String dateStamp;

}
