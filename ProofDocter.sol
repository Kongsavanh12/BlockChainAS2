// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract ProofDoctor {

    // โครงสร้างข้อมูลของผู้ป่วย
    struct Patient {
        string name;
        string idCard;
        string bloodType;
        uint age;
        string allergies;
        string chronicDiseases;
        string lastVisitDate;
        string lastDiagnosis;
        address addedBy;
    }

    // Mapping เพื่อเก็บข้อมูลผู้ป่วย
    mapping(bytes32 => Patient) private patients;

    // อีเวนต์
    event PatientAdded(address indexed doctor, string name, bytes32 hash);
    event PatientSearched(address indexed searcher, string name, string details);

    // ฟังก์ชันเพิ่มข้อมูลผู้ป่วย
    function addPatient(
        string memory name,
        string memory idCard,
        string memory bloodType,
        uint age,
        string memory allergies,
        string memory chronicDiseases,
        string memory lastVisitDate,
        string memory lastDiagnosis
    ) public {
        bytes32 nameHash = hashing(name);

        require(bytes(patients[nameHash].name).length == 0, "Patient already exists!");

        patients[nameHash] = Patient({
            name: name,
            idCard: idCard,
            bloodType: bloodType,
            age: age,
            allergies: allergies,
            chronicDiseases: chronicDiseases,
            lastVisitDate: lastVisitDate,
            lastDiagnosis: lastDiagnosis,
            addedBy: msg.sender
        });

        emit PatientAdded(msg.sender, name, nameHash);
    }

    // ฟังก์ชันค้นหาผู้ป่วย
    function searchPatient(string memory name) public view returns (
        string memory, string memory, string memory, uint, string memory, string memory, string memory, string memory
    ) {
        bytes32 nameHash = hashing(name);

        require(bytes(patients[nameHash].name).length > 0, "Patient not found!");

        Patient memory patient = patients[nameHash];

        return (
            patient.name,
            patient.idCard,
            patient.bloodType,
            patient.age,
            patient.allergies,
            patient.chronicDiseases,
            patient.lastVisitDate,
            patient.lastDiagnosis
        );
    }

    // ฟังก์ชันสำหรับแฮชชื่อของผู้ป่วย
    function hashing(string memory name) private pure returns (bytes32) {
        return sha256(bytes(name));
    }
}
