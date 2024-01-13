# KTCLOUD-INIT
이 프로젝트는 케이티 클라우드 하이퍼바이저의 메타 데이터를 수집하여 인스턴스를 초기화하는 스크립트와
Systemd 유닛을 포함합니다. 패키지는 일반 클라우드 베이스 이미지를 이용해 커스텀 이미지를 때 사용할
시 활용할 수 있도록 고안되었습니다.

(c) 2024 David Timber &lt;dxdt 𝕒𝕥 dev.snart.me&gt; 저술

포함된 스크립트는 [cloud-init](https://cloud-init.io/)에 이미 구현된 기능이 담겨져
있습니다. 아파치 클라우드스택에 포함된 스크립트들이 케이티 클라우드 이미지에 포함되어 있는 것을 볼
때, 케이티 클라우드는 아마 아파치 클라우드스택에 기반하고 있을 것으로 보입니다[^1].

패키지에 포함된 스크립트는 최신 배포판에서 동작할 수 있도록 수정되었습니다. 수정 사항은 다음과
같습니다.

- curl을 사용하여 wget 종속성 제거
- NetworkManager 사용
- 미사용 기능 제거
  - netconsole (케이티 클라우드에서 사용되지 않으며, 대부분의 클라우드에서는 시리얼 포트를 사용함)
  - xe-linux-distribution 제거 (최신 배포판 커널에 기능이 빌드되지 않음)

대부분 사용 케이스에서는 배포판에 담겨오는 cloud-init만 사용해도 충분합니다. 정말로 이 패키지를
사용해야 하는지는 아래를 확인하십시오.

[^1]: https://docs.cloudstack.apache.org/en/latest/adminguide/virtual_machines.html#user-data-and-meta-data

## 고려사항
| Script | cloud-init | But ... |
| - | - | - |
| cloud-set-guest-sshkey.in | YES | 안전하지 않음([see here](doc/ssh_rsa-keylen.kr.md)) |
| cloud-set-guest-password | YES | cloud-init에서 wget이 사용됨[^2] |
| sethostname2.sh | NO | 호스트명을 인스턴스 이름으로 설정하는 기능을 케이티 클라우드의 고유 기능입니다. 이 기능은 하이퍼바이저가 DHCP 응답에 호스트명을 포함하는지의 여부를 사용해 제어됩니다. |
| userdataExecutor | NO | 유저 데이터를 다운로드하여 스크립트로 실행하는 기능은 케이트 클라우드의 고유 기능입니다. |

종합하면, 마지막 두 요구사항을 충족할 필요가 없으면 cloud-init과 wget을 설치하는 것만으로도
케이티 클라우드에 일반 배포판 클라우드 베이스 이미지를 사용할 수 있을 것입니다. Cloud-init을
아파치 클라우드스택에 맞게 설정하려면 다음을 참조하십시오.

https://github.com/canonical/cloud-init/blob/1baa9ff060b549391fd6e29028ac78311b5df58b/doc/rtd/reference/datasources/cloudstack.rst#L19

만약 마지막 두 요구사항을 충족해야 하여야 할 경우 계속 진행해주세요.

[^2]: https://github.com/canonical/cloud-init/blob/1baa9ff060b549391fd6e29028ac78311b5df58b/cloudinit/sources/DataSourceCloudStack.py#L49

## 설치
베이스 이미지에서 cloud-init이나 다른 init 스크립트가 작동된다면 비활성화 하십시오.

```sh
sudo touch /etc/cloud/cloud-init.disabled
```

최신판 패키지를 다운로드 후 패키지 매니저로 설치하십시오.

```sh
curl -O https://github.com/si-magic/ktcloud-init/releases/download/latest/ktcloud-init-latest.rpm
sudo dnf install ktcloud-init-latest.rpm
```

서비스를 활성화시켜 다음 부팅 때 동작하도록 하십시오.

```sh
sudo systemctl enable ktcloud-init
```

끝입니다.

만약 이 패키지를 케이티 클라우드에서 제공하는 이미지에 적용하려면 다음 순서를 따르십시오.

### 마이그레이션
이 패키지는 케이티 클라우드 이미지에 적용된 rc.d 스크립트와 호환되지 않습니다. 케이티 클라우드에서
제공된 이미지에 적용하려면 기존 스크립트를 제거애햐 합니다. 패키지 설치 후
`/usr/libexec/ktcloud-init/uninstall-ktcloud-rc.d.sh`를 직접 실행하여 제거하십시오.
